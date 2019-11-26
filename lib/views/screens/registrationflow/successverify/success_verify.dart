import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class VerifySuccess extends StatefulWidget {
  @override
  _VerifySuccessState createState() => _VerifySuccessState();
}

class _VerifySuccessState extends State<VerifySuccess> {

  @override
  void initState() {
    super.initState();
    continueRegistrationScreen();
  }

  @override
  Widget build(BuildContext context) {
    double firstCircleSize = MediaQuery.of(context).size.width * 0.3;
    double secondCircleSize = MediaQuery.of(context).size.width * 0.45;
    double thirdCircleSize = MediaQuery.of(context).size.width * 0.6;
    double fourthCircleSize = MediaQuery.of(context).size.width * 0.75;

    double iconSize = MediaQuery.of(context).size.width * 0.2;

    Color firstColor = Colors.yellow[800].withOpacity(0.6);
    Color secondColor = Colors.yellow[800].withOpacity(0.5);
    Color thirdColor = Colors.yellow[800].withOpacity(0.4);
    Color fourthColor = Colors.yellow[800].withOpacity(0.3);

    return MainBackground(
      child: buildCircle(
        fourthCircleSize,
        fourthColor,
        buildCircle(
          thirdCircleSize,
          thirdColor,
          buildCircle(
              secondCircleSize,
              secondColor,
              buildCircle(
                firstCircleSize,
                firstColor,
                acceptIcon(iconSize)
              )
          )
        )
      ),
    );
  }

  Widget acceptIcon(double size) {
    return Center(
      child: Icon(Icons.check,color: Colors.grey[900], size: size,),
    );
  }

  Widget buildCircle(double size, Color color, Widget child) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color
        ),
        child: child,
      ),
    );
  }

  continueRegistrationScreen() async {
    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacementNamed(context, '/setage');
    });
  }

}
