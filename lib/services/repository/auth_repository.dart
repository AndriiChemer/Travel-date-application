
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password) async {
    print("Auth");
    print("signIn");
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    print("Auth");
    print("signUp");
    _firebaseAuth = FirebaseAuth.instance;

    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    print("Auth");
    print("getCurrentUser");
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    print("Auth");
    print("signOut");
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    print("Auth");
    print("sendEmailVerification");
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    print("Auth");
    print("isEmailVerified");
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}