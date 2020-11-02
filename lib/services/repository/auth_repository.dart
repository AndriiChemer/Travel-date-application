
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:http/http.dart' as http;


abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<UserModel> googleSignIn();

  Future<UserModel> instagramSignIn();

  Future<UserModel> facebookSignIn();

  Future<FirebaseUser> appleSignIn();

  Future<void> resetPassword(String email);
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

  Future<bool> signOut() async {
    print("Auth");
    print("signOut");
    await _facebookSignIn.logOut();
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    return true;
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
    if(_googleSignIn.currentUser != null) {
      print("googleSignIn.currentUser is not null");
    } else {
      print("googleSignIn.currentUser is null");
    }
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print("googleSignIn 1");
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("googleSignIn 2");

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );
    print("googleSignIn 3");

    AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    print("googleSignIn 4");
    FirebaseUser firebaseUser = authResult.user;
    print("googleSignIn 5");


    print("currentUser.uid: " + firebaseUser.uid);
    return firebaseUser;
  }

  @override
  Future<UserModel> googleSignIn() async {
    print("googleSignIn");
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );

    AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    //TODO get photo from google account
    FirebaseUser firebaseUser = authResult.user;
    ///We don't have photo yet
    UserModel userModel = _getUserModel(firebaseUser, '');

    print("currentUser.uid: " + firebaseUser.uid);
    return userModel;
  }

  @override
  Future<UserModel> facebookSignIn() async {
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

        FirebaseUser firebaseUser = (await _firebaseAuth.signInWithCredential(authCredential)).user;
        var userPhotoUrl = '';//await _getUrlFromFacebook(firebaseUser, accessToken.token);
        //TODO add photo 
        UserModel user = _getUserModel(firebaseUser, userPhotoUrl);

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

  Future<String> _getUrlFromFacebook(FirebaseUser firebaseUser, String accessToken) async {
    if (firebaseUser.photoUrl != null) {
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=$accessToken');
      final Map facebookBody = json.decode(graphResponse.body);
      var userFacebookModel = UserFacebookModel.fromMap(facebookBody);
      return userFacebookModel.picture.data.url;
    } else {
      return '';
    }
  }

  UserModel _getUserModel(FirebaseUser firebaseUser, String photo) {
    var userModel = UserModel();
    if(firebaseUser.displayName != null) {
      userModel.name = firebaseUser.displayName;
    }

    if(firebaseUser.phoneNumber != null) {
      userModel.phone = firebaseUser.phoneNumber;
    }
    userModel.id = firebaseUser.uid;
    userModel.email = firebaseUser.email;
    userModel.dateCreated = DateTime.now().millisecondsSinceEpoch;
    userModel.isOnline = true;
    userModel.imageUrl = photo;

    return userModel;
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserModel> instagramSignIn() async {
    String url = 'https://api.instagram.com/oauth/authorize?client_id=317178079336950&redirect_uri=vk.com&response_type=123&scope=user_profile,user_media&state=3';
    await http.get(url);

    throw UnimplementedError();
  }
}