
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<FirebaseUser> googleSignIn();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

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
    _googleSignIn.signOut();
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

  @override
  Future<FirebaseUser> googleSignIn() async {
    print("googleSignIn");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser userDetails = authResult.user;

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    print("googleSignIn result, FirebaseUser:");
    print("currentUser.displayName: " + currentUser.displayName);
    print("currentUser.email: " + currentUser.email);
    if(currentUser.phoneNumber != null) {
      print("currentUser.phoneNumber: " + currentUser.phoneNumber);
    }
    print("currentUser.uid: " + currentUser.uid);

    print("googleSignIn result, user: ");
    print("currentUser.displayName: " + userDetails.displayName);
    print("currentUser.email: " + userDetails.email);
    if(userDetails.phoneNumber != null) {
      print("currentUser.phoneNumber: " + userDetails.phoneNumber);
    }

    //TODO clean code
    print("currentUser.uid: " + userDetails.uid);
    return userDetails;
  }




}