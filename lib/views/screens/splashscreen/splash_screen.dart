import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/screens/errorscreen/error_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  bool isLoading = false;

  Auth auth = Auth();
  UserPreferences userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();

    userPreferences.isLoggedIn().then((isLoggedIn) {
      // if  user logged in
      if(isLoggedIn) {
        showProgress();

        userPreferences.getUser().then((user) {
          auth.signIn(user.email, user.password).then((firebaseUser) {
            openMainScreen(user);
          }).catchError((error) {
            print(error);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorScreen()));
          });
        });

      } else {
        // if user not logged in
        openSignInScreen();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      child: _loading(),
      color: CustomColors.mainBackground,
    ) : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_background.jpeg"),
          fit: BoxFit.cover,
        )
      ),
      child: Container(
        padding: EdgeInsets.all(40),
        child: Image.asset("assets/images/logo_big.png"),
      )
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitFadingCube(
        color: Colors.yellow[800],
        size: 80,
      ),
    );
  }

  Future<Timer> showProgress() async {
    return Timer(Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  Future<Timer> openSignInScreen() async {
    return Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/signin');
    });
  }

  openMainScreen(UserModel userModel) {
    Navigator.pushReplacementNamed(context, '/main', arguments: {"user" : userModel});
  }
}