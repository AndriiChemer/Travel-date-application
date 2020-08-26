import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/LocationService.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/screens/registrationflow/registrationscreen/registration_screen.dart';
import 'package:travel_date_app/views/screens/signin/sign_in_bloc.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  SignInBloc signInBloc;
  BottomNavBloc bottomNavBloc;

  bool _autoValidate = false;

  @override
  void initState() {
    bottomNavBloc = BlocProvider.getBloc<BottomNavBloc>();
    signInBloc = BlocProvider.getBloc<SignInBloc>();
    bottomNavBloc.setNavIndexPage(0);
    _blocStreamListener();
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
        onPressed: _signInPressed,
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
          _buildSocialMediaButton("facebook", "assets/images/socialmedia/facebook.png", _facebookSignInPressed),
          _buildSocialMediaButton("google-plus", "assets/images/socialmedia/google-plus.png", _googleSignInPressed),
          _buildSocialMediaButton("instagram", "assets/images/socialmedia/instagram.png", showFeatureNotImplementedYet),
          _buildSocialMediaButton("apple", "assets/images/socialmedia/apple.png", showFeatureNotImplementedYet),
        ],
      ),
    );
  }

  Widget _buildSocialMediaButton(String tag, String assetPath, VoidCallback onPressed) {
    return FloatingActionButton(
      heroTag: tag,
      backgroundColor: Colors.white,
      child: Image.asset(assetPath),
      onPressed: onPressed,
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
    _showSnackBar("This feature not implemented yet!");
  }

  void showErrorMessage(String errorMessage) {
    _showSnackBar(errorMessage);
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red[900],
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _googleSignInPressed() {
    signInBloc.onGoogleSignInPressed();
  }

  void _facebookSignInPressed() {
    signInBloc.onFacebookSignInPressed();
  }

  void _onSignOut() {
    signInBloc.onSignOutPressed();
  }

  //TODO validation
  void _signInPressed() {
    print("Valid form: ${_formKey.currentState.validate()}");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signInBloc.onSignInPressed(emailController.text, passwordController.text);
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

  void _blocStreamListener() {
    signInBloc.errorStream.listen((message) {
      if(message != null) {
        showErrorMessage(message);
      }
    });

    signInBloc.mainScreenStream.listen((existingUser) {
      print("emit mainScreenStream");
      if(existingUser != null) {
        Navigator.pushReplacementNamed(context, '/mainNavigation', arguments: existingUser);
      }
    });

    signInBloc.socialMediaScreenStream.listen((newUser) {
      print("emit socialMediaScreenStream");
      if(newUser != null) {
        Navigator.pushNamed(context, '/setuserdetails', arguments: newUser);
      }
    });
  }
}
