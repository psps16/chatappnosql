import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Sign in
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print("Attempting to sign in user: $email"); // Debug print
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      print("User signed in successfully, saving to Firestore..."); // Debug print
      
      // Always save user info
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'lastSignIn': FieldValue.serverTimestamp(), // Add last sign-in time
      }, SetOptions(merge: true));

      print("User data saved to Firestore for ID: ${userCredential.user!.uid}"); // Debug print

      // Verify the user was saved by reading it back
      final userDoc = await _firestore.collection("Users").doc(userCredential.user!.uid).get();
      print("Verified user data in Firestore: ${userDoc.data()}"); // Debug print

      notifyListeners();
      return userCredential;

    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}"); // Debug print
      throw Exception(e.code);
    }
  }

  //Sign up
  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      print("Attempting to create new user: $email"); // Debug print
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      print("User created in Authentication, saving to Firestore..."); // Debug print
      
      // Save user info in a separate doc
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(), // Add creation time
      });
      
      print("User created in Firestore with ID: ${userCredential.user!.uid}"); // Debug print
      
      // Verify the user was saved by reading it back
      final userDoc = await _firestore.collection("Users").doc(userCredential.user!.uid).get();
      print("Verified user data in Firestore: ${userDoc.data()}"); // Debug print
      
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}"); // Debug print
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
  
  User? getCurrentUser(){
    return _auth.currentUser;
  }
}