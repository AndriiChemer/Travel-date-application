import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/ErrorHandler.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/strings.dart';

class SignInBloc extends BlocBase {
  SignInBloc();

  Auth _auth = Auth();
  UserRepository _userRepository = UserRepository();
  UserPreferences _userPreferences = UserPreferences();

  /// Error message
  var messageErrorController = BehaviorSubject<String>();
  Stream<String> get errorStream => messageErrorController.stream;
  Sink<String> get messageErrorSink => messageErrorController.sink;

  /// Open main screen
  var mainScreenController = BehaviorSubject<UserModel>();
  Stream<UserModel> get mainScreenStream => mainScreenController.stream;
  Sink<UserModel> get mainScreenErrorSink => mainScreenController.sink;

  /// Sign In using social media screen
  var socialMediaScreenController = BehaviorSubject<UserModel>();
  Stream<UserModel> get socialMediaScreenStream => socialMediaScreenController.stream;
  Sink<UserModel> get socialMediaScreenErrorSink => socialMediaScreenController.sink;

  void onGoogleSignInPressed() {
    _auth.googleSignIn().then((user) {
      _getUserById(user);
    }).catchError((onError) {
      _showErrorMessage(onError);
    });
  }

  void onFacebookSignInPressed() {
    _auth.facebookSignIn().then((user) {
      _getUserById(user);
    }).catchError((onError) {
      _showErrorMessage(onError);
    });
  }

  void onSignOutPressed() {
    messageErrorSink.add(null);
    mainScreenErrorSink.add(null);
    socialMediaScreenErrorSink.add(null);
    _userPreferences.getUserId().then((userId) {
      _userRepository.handleOnlineState(userId, false);
    });
    _userPreferences.logout();
    _auth.signOut();
  }

  void _getUserById(UserModel user) {
    Future.wait([_userRepository.isUserExist(user.id), _userRepository.getUsersById(user.id)])
        .then((List responses) => _checkUserResponses(responses, user))
        .catchError((onError) {
          _showErrorMessage(onError);
        });
  }

  void _checkUserResponses(List responses, UserModel newUser) {
    bool isUserExist = responses[0];
    UserModel existingUser = responses[1];

    if(isUserExist) {
      print(existingUser.toJson().toString());
      _userPreferences.writeUser(existingUser);
      _userPreferences.saveLoggedIn();
      mainScreenErrorSink.add(existingUser);
    } else {
      socialMediaScreenErrorSink.add(newUser);
    }
  }

  @override
  void dispose() {
    messageErrorController.close();
    mainScreenController.close();
    socialMediaScreenController.close();
    super.dispose();
  }

  void onSignInPressed(String email, String password) {
    _auth.signIn(email, password)
        .then((firebaseUser) {
      _signInSuccess(firebaseUser);
    }).catchError((onError) {
      var platformError = onError as PlatformException;
      print("code: ${platformError.code} | detail: ${platformError.details} | message: ${platformError.message}");
      _showErrorMessage(platformError);
    });
  }

  void _showErrorMessage(onError) {
    print('error: ' + onError.toString());
    var errorMessage = ErrorHandler.getErrorMessage(onError);
    messageErrorSink.add(errorMessage);
  }

  void _signInSuccess(FirebaseUser firebaseUser) {
    _userRepository.getUsersById(firebaseUser.uid)
        .then((user) {
          if(user != null) {
            _userPreferences.writeUser(user);
            _userPreferences.saveLoggedIn();
            mainScreenErrorSink.add(user);
          } else {
            messageErrorSink.add(Strings.user_not_exist);
          }
        })
        .catchError((onError) {
          _showErrorMessage(onError);
        });
  }

  void onResetPasswordClicked(String email) {
    if(email != null) {
      print("Reset password for email: $email");
      _auth.resetPassword(email);
    }
  }
}