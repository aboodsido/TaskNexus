import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthClass {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String pass) async {
    await _auth.createUserWithEmailAndPassword(
        email: email.toLowerCase(), password: pass);
  }

  Future<void> login(String email, String pass) async {
    await _auth.signInWithEmailAndPassword(
        email: email.toLowerCase(), password: pass);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
