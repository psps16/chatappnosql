import 'package:chatappnosql/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth & firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GET ALL USERS STREAM
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList()
    );
  }


  // GET ALL USERS STREAM EXCEPT BLOCKED USERS
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser!;
    print("Current user: ${currentUser.email} (${currentUser.uid})"); // Added UID to debug print

    return _firestore
        .collection('Users')
        .snapshots()
        .asyncMap((usersSnapshot) async {
          print("Found ${usersSnapshot.docs.length} total users"); // Debug print
          print("Raw user data: ${usersSnapshot.docs.map((doc) => doc.data())}"); // Print raw data
          
          // Get blocked users
          final blockedUsersSnapshot = await _firestore
              .collection('Users')
              .doc(currentUser.uid)
              .collection('BlockedUsers')
              .get();

          final blockedUserIds = blockedUsersSnapshot.docs.map((doc) => doc.id).toList();
          print("Blocked users: $blockedUserIds"); // Debug print

          // Filter users and include document ID
          final users = usersSnapshot.docs
              .map((doc) {
                final data = doc.data();
                data['uid'] = doc.id; // Ensure uid is set from document ID
                print("Processing user: ${data['email']} (${data['uid']})"); // Debug each user
                return data;
              })
              .where((user) {
                final isCurrentUser = user['uid'] == currentUser.uid;
                final isBlocked = blockedUserIds.contains(user['uid']);
                print("User ${user['email']}: isCurrentUser=$isCurrentUser, isBlocked=$isBlocked"); // Debug filtering
                return !isCurrentUser && !isBlocked;
              })
              .toList();
          
          print("Filtered users: ${users.length}"); // Debug print
          print("Final user data: $users"); // Debug print
          return users;
        });
  }


  // SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    try {
      // get current user info
      final currentUser = _auth.currentUser!;
      print("Sending message from ${currentUser.email} to $receiverId"); // Debug print

      final String currentUserID = currentUser.uid;
      final String currentEmail = currentUser.email!;

      final Timestamp timestamp = Timestamp.now(); // Time message was sent

      // create a new message
      Message newMessage = Message(
        senderId: currentUserID,
        senderEmail: currentEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
      );

      // construct chat room ID for the two users (sorted to ensure uniqueness)
      List<String> ids = [currentUserID, receiverId];
      ids.sort(); // Sort the IDs alphabetically to be consistent for any pair of users

      String chatRoomId = ids.join('_');
      print("Creating/using chat room: $chatRoomId"); // Debug print
       
      // add new message to database
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .set({  // Create the chat room document first
            'participants': [currentUserID, receiverId],
            'lastMessage': message,
            'lastMessageTime': timestamp,
          });

      print("Chat room created/updated"); // Debug print

      // Add the message to the messages subcollection
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      print("Message added successfully"); // Debug print
    } catch (e) {
      print("Error sending message: $e"); // Debug print error
      throw Exception("Failed to send message: $e");
    }
  }


  // GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct a chatroom ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false) // Order messages by timestamp
        .snapshots();
  }


  // REPORT USER
  Future<void> reportUser(String messageId, String userId) async {
    final currentUser = _auth.currentUser!;
    final report = {
      'reportedBy': currentUser.uid,
      'messageId': messageId,
      'messageOwner': userId, // The ID of the user who sent the message
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('Reports').add(report);
  }


  // BLOCK USER
  Future<void> blockUser(String userId) async {
    final currentUser = _auth.currentUser!;
    await _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('BlockedUsers')
        .doc(userId)
        .set({});  // An empty map is sufficient to represent blocking
    notifyListeners(); // Notify listeners
  }


  // UNBLOCK USER
  Future<void> unblockUser(String blockedUserId) async {
    final currentUser = _auth.currentUser!;
    await _firestore
        .collection('Users')
        .doc(currentUser.uid)
        .collection('BlockedUsers')
        .doc(blockedUserId)
        .delete();
    notifyListeners(); // Notify listeners
  }


  // GET BLOCKED USERS STREAM
  Stream<List<Map<String, dynamic>>> getBlockedUsersStream(String userId) {
    return _firestore
        .collection('Users')
        .doc(userId)
        .collection('BlockedUsers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}