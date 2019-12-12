import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/colors.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.mainBackground,
      child: Center(
        child: Text("Error", style: TextStyle(color: Colors.white, fontSize: 35),),
      ),
    );
  }
}
