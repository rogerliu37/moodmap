import 'package:firebase_auth/firebase_auth.dart';
import 'UserModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? getCurrentUser() {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return UserModel(id: user.uid, email: user.email ?? "", username: "");
  }

  Future<UserModel?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
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
      return UserModel(id: user.uid, email: user.email ?? "", username: "");
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
      return UserModel(id: user.uid, email: user.email ?? "", username: "");
    } on FirebaseAuthException catch (e) {
      print("signInWithEmailAndPassword error: ${e.message}");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
