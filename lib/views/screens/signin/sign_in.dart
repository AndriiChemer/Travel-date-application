import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/LocationService.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/screens/registrationflow/registrationscreen/registration_screen.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';
import 'package:location/location.dart' as locationPackage;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  UserPreferences _userPreferences = UserPreferences();
  UserRepository _userRepository = UserRepository();
  Auth _auth = Auth();

  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    LocationService().checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 100),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.sign_in, style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),),
                _marginHeight(60),
                _emailOrPhoneInputField(),
                _marginHeight(20),
                _passwordTextField(),
                _marginHeight(20),
                _forgotPassword(context),
                _marginHeight(20),
                _buttonSignIn(context),
                _marginHeight(30),
                _or(),
                _marginHeight(30),
                _socialMedias(),
                _marginHeight(30),
                _signUnButton(),
                _marginHeight(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonSignIn(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        color: Colors.yellow[800],
        textColor: Colors.white,
        child: Text(Strings.sign_in.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
        onPressed: () {
          _signInPressed();
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _emailOrPhoneInputField() {
    return TextFormField(
      autofocus: false,
      validator: ValidateFields.emailOrPasswordValidate,
      controller: emailController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.emailPassword,
          prefixIcon: Icon(Icons.person, color: Colors.grey[800],),
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          )
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.visiblePassword,
      controller: passwordController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      validator: ValidateFields.isPasswordValid,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.password,
          prefixIcon: Icon(Icons.lock, color: Colors.grey[800],),
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          )
      ),
    );
  }

  Widget _forgotPassword(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: showFeatureNotImplementedYet,
          child: Text("Forgot Password", style: TextStyle(decoration: TextDecoration.underline, color: Colors.yellow[800]),),
        ),
      ),
    );
  }

  Widget _or() {
    return Center(
      child: GestureDetector(
        onDoubleTap: _onSignOut,
        child: Text(Strings.or.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
    );
  }

  Widget _marginHeight(double height) {
    return Flexible(
      child: SizedBox(
        height: height,
      ),
    );
  }

  Widget _socialMedias() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "facebook",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/facebook.png"),
            onPressed: _facebookSignInPressed,
          ),

          FloatingActionButton(
            heroTag: "google-plus",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/google-plus.png"),
            onPressed: _googleSignInPressed,
          ),

          FloatingActionButton(
            heroTag: "instagram",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/instagram.png"),
            onPressed: (){
              showFeatureNotImplementedYet();
            },
          ),

          FloatingActionButton(
            heroTag: "apple",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/apple.png"),
            onPressed: showFeatureNotImplementedYet,
          )
        ],
      ),
    );
  }

  Widget _signUnButton() {
    return Center(
      child: RichText(
        text: TextSpan(
            text: Strings.dontHaveAccount,
            style: TextStyle(color: Colors.white, fontSize: 17),
            children: [
              TextSpan(
                  text: Strings.sign_up,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                    }
              ),
            ]
        ),
      ),
    );
  }

  void showFeatureNotImplementedYet() {
    final snackBar = SnackBar(
      content: Text("This feature not implemented yet!", style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showErrorMessage(String errorMessage) {
    print("onError = " + errorMessage);
    final snackBar = SnackBar(
      content: Text(errorMessage, style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _googleSignInPressed() {
    _auth.googleSignIn().then((user) {
      getUserById(user);
    }).catchError((onError) {
      print('error: ' + onError.toString());
      showErrorMessage(onError.toString());
    });
  }

  void _facebookSignInPressed() {
    _auth.facebookSignIn().then((user) {
      getUserById(user);
    }).catchError((onError) {
      print('error: ' + onError.toString());
      showErrorMessage(onError.toString());
    });
  }

  void getUserById(UserModel user) {
    Future.wait([_userRepository.isUserExist(user.id), _userRepository.getUsersById(user.id)])
        .then((List responses) => checkUserResponses(responses, user))
        .catchError((onError) => showErrorMessage(onError.toString()));
  }

  void _onSignOut() {
    _auth.signOut();
  }

  void _signInPressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _auth.signIn(emailController.text, passwordController.text)
          .then((firebaseUser) {
        signInSuccess(firebaseUser);
      }).then((onError) {
        showErrorMessage(onError.toString());
      });
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void checkUserResponses(List responses, UserModel newUser) {
    bool isUserExist = responses[0];
    UserModel existingUser = responses[1];

    if(isUserExist) {
      print(existingUser.toJson().toString());
      _userPreferences.writeUser(existingUser);
      _userPreferences.saveLoggedIn();
      Navigator.pushReplacementNamed(context, '/mainNavigation', arguments: existingUser);
    } else {
      Navigator.pushNamed(context, '/setuserdetails', arguments: newUser);
    }
  }

  void signInSuccess(FirebaseUser firebaseUser) {}
}
