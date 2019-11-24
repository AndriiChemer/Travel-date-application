import 'package:flutter/material.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class AgeScreen extends StatefulWidget {
  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {

  bool isMale = false;
  bool isFemale = false;

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(30),
          margin: EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              arrowBack(),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              Text(Strings.who_are_you, style: TextStyle(color: Colors.white, fontSize: 35),),
              Flexible(
                child: SizedBox(height: 50,),
              ),
              _maleButton(context),
              Flexible(
                child: SizedBox(height: 15,),
              ),
              _femaleButton(context),
              Flexible(
                child: SizedBox(height: 50,),
              ),
              Text(Strings.age_title, style: TextStyle(color: Colors.white, fontSize: 35),),
            ],
          ),
        ),
      ),
    );
  }

  Widget arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
    );
  }

  Widget _maleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMale = true;
          isFemale = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: isMale ? Colors.yellow[800] : Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 20, left: 10),
              child: Image.asset('assets/images/material/man_icon.png'),
            ),
            Text(Strings.male, style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }

  Widget _femaleButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFemale = true;
          isMale = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: isFemale ? Colors.yellow[800] : Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 20, left: 10),
              child: Image.asset('assets/images/material/women_icon.png'),
            ),
            Text(Strings.female, style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }

  Widget femaleButton() {

  }
}
