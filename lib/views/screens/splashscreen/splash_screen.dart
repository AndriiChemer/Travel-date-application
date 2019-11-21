import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() {
    Navigator.pushReplacementNamed(context, '/singup');
  }
}