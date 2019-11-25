import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/authflow/selectinterest/interests.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class AgeScreen extends StatefulWidget {
  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String birthDate = "";
  String errorMessage = "";
  int age = -1;

  bool isMale = false;
  bool isFemale = false;
  bool isErrorVisible = false;

  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.all(20),
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
              Flexible(child: SizedBox(height: 50,),),
              _selectAgeButton(context),
              Flexible(child: SizedBox(height: 50,),),
              _nextButton(context)
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

  Widget _selectAgeButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _showDateDialog(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(age == -1 ? Strings.select_age : age.toString(), style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }

  _showDateDialog(BuildContext context) {
    if(Platform.isAndroid) {
      _selectDate(context).then((DateTime selectedDate){
        _parseDate(selectedDate);
        setState(() {});
      });
    } else {
      _showIosDateBottomDialog(context);
    }
  }

  calculateAge(DateTime birthDate) {
    print(birthDate);
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int currentMonth = currentDate.month;
    int birthMonth = birthDate.month;
    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = currentDate.day;
      int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age;
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime nowDate = DateTime.now();

    final DateTime birthDate = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: DateTime(1920, 8),
        lastDate: DateTime(nowDate.year - 16));

    return birthDate;
  }

  _parseDate(DateTime date) {
    final df = new DateFormat('dd-MMM-yyyy');
    this.birthDate = df.format(date);
    this.age = calculateAge(date);
  }

  _showIosDateBottomDialog(BuildContext context) {
    DateTime nowDate = DateTime(1970, 1);
    DateTime maxDate = DateTime(DateTime.now().year - 16, 1);

    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 260,
          color: Colors.transparent,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),

              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(child: SizedBox(
                    height: 20,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _parseDate(_selectedDate);
                          Navigator.pop(context);
                        });
                      },
                      child: Text(Strings.select_button, style: TextStyle(color: Colors.blue[400]),),
                    ),
                  ),),
                  Flexible(child: SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                      initialDateTime: nowDate,
                      minimumDate: nowDate,
                      maximumDate: maxDate,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (selectedDate) {
                        this._selectedDate = selectedDate;
                      },
                    ),
                  ),)
                ],
              ),
          ),
        )
    );
  }

  Widget _nextButton(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        color: Colors.yellow[800],
        textColor: Colors.white,
        child: Text(Strings.next.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
        onPressed: () {
          _onButtonNextClick();
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  _onButtonNextClick() {
    if(isMale == false && isFemale == false) {
      showErrorMessage(Strings.age_error);
       return;
    }

    if(_selectedDate == null) {
      showErrorMessage(Strings.male_error);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => InterestsScreen()));
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
