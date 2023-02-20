import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user with email and password
  Future<String?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create a new user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .set(UserModel(
            id: result.user!.uid,
            username: username,
            email: result.user!.email!,
          ).toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign in an existing user with email and password
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get the current user
  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, email: user.email!, username: "");
    } else {
      return null;
    }
  }

  // Delete the current user's account
  Future<String?> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Delete the user document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Delete the user's account
        await user.delete();
        return null;
      } else {
        return "User not found";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
