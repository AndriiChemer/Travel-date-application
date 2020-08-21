
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_date_app/utils/strings.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<FirebaseUser> googleSignIn();

  Future<FirebaseUser> facebookSignIn();

  Future<FirebaseUser> appleSignIn();
}

class Auth implements BaseAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FacebookLogin _facebookSignIn = new FacebookLogin();

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
    _facebookSignIn.logOut();
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
  Future<FirebaseUser> appleSignIn() async {
    print("googleSignIn");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    FirebaseUser userDetails = authResult.user;

    print("currentUser.uid: " + userDetails.uid);
    return userDetails;
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

    print("currentUser.uid: " + userDetails.uid);
    return userDetails;
  }

  @override
  Future<FirebaseUser> facebookSignIn() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        AuthCredential authCredential = FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        debugPrint('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        FirebaseUser user = (await _firebaseAuth.signInWithCredential(authCredential)).user;
        debugPrint("user data: \nid: ${user.uid} \nName: ${user.displayName} \nEmail: ${user.email} \nPhoto: ${user.photoUrl} \Phone: ${user.phoneNumber}");
        return user;
      case FacebookLoginStatus.cancelledByUser:
        debugPrint('Login cancelled by the user.');
        throw(Strings.facebook_login_cancel);
      case FacebookLoginStatus.error:
        debugPrint(Strings.facebook_error_message + result.errorMessage);
        throw(Strings.facebook_error_message + result.errorMessage);
    }

    return null;
  }

}