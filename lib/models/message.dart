import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail; // Added senderEmail
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  // Convert Message object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // Factory constructor to create a Message from a Firestore DocumentSnapshot
  factory Message.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Message(
      senderId: data['senderId'],
      senderEmail: data['senderEmail'],
      receiverId: data['receiverId'],
      message: data['message'],
      timestamp: data['timestamp'],
    );
  }
}