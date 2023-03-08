import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel(
        id: user.uid, email: user.email ?? "", username: "", password: "");
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String username}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      // Save the user's username in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'username': username});

      return UserModel(
          id: user.uid,
          email: user.email ?? "",
          username: username,
          password: password);
    } on FirebaseAuthException catch (e) {
      print("createUserWithEmailAndPassword error: ${e.message}");
      return null;
    }
  }

Future<UserModel?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) {
        return null;
      }
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _db.collection('users').doc(user.uid).get();
      return UserModel(
          id: user.uid,
          email: user.email ?? "",
          username: userDoc.data()?['username'] ?? "",
          password: password);
    } on FirebaseAuthException catch (e) {
      print("signInWithEmailAndPassword error: ${e.message}");
      return null;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }
}
