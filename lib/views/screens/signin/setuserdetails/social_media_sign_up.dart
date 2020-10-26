
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/dialogs.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

import 'social_media_sign_up_bloc.dart';

class SocialMediaSignUp extends StatefulWidget {
  @override
  _SocialMediaSignUpState createState() => _SocialMediaSignUpState();
}

class _SocialMediaSignUpState extends State<SocialMediaSignUp> {

  Auth _auth = Auth();
  SocialMediaSignUpBloc userDetailBloc;

  DateTime _selectedDate;
  int state;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userDetailBloc = BlocProvider.getBloc<SocialMediaSignUpBloc>();
    userDetailBloc.getCurrentLocation();
    prepareListeners();
    super.initState();
  }

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
                _arrowBack(),
                _flexibleHeight(30),
                Text(Strings.who_are_you, style: TextStyle(color: Colors.white, fontSize: 35),),
                _flexibleHeight(50),
                _buildMaleButton(),
                _flexibleHeight(15),
                _buildFemaleButton(),
                _flexibleHeight(50),
                Text(Strings.age_title, style: TextStyle(color: Colors.white, fontSize: 35),),
                _flexibleHeight(50),
                _selectAgeButton(context),
                _flexibleHeight(40),
                _nextButton(context)
              ],
            ),
          ),
        )
    );
  }

  Widget _loading() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.yellow[800],
          size: 30,
        ),
      ),
    );
  }

  Widget _flexibleHeight(double height) {
    return Flexible(
      child: SizedBox(height: height,),
    );
  }

  Widget _arrowBack() {
    return GestureDetector(
      onTap: () {
        _arrowBackClicked();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
    );
  }

  Widget _buttonBuilder({
    @required GestureTapCallback onTap,
    @required Color color,
    @required String assetImagePath,
    @required String buttonText}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: color
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 20, left: 10),
              child: Image.asset(assetImagePath),
            ),
            Text(buttonText, style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }

  void onLogoutClick() {
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (Route<dynamic> route) => false);
  }

  Widget _buildMaleButton() {
    onTap() {
      userDetailBloc.setUserState(0);
    }
    return StreamBuilder(
      stream: userDetailBloc.stateStream,
      builder: (context, snapshot) {
        int state = snapshot.data;
        ///state = 0 - male
        Color color = state == 0 ? Colors.yellow[800] : Colors.white;
        String assetImage = 'assets/images/material/man_icon.png';
        return _buttonBuilder(onTap: onTap, color: color, assetImagePath: assetImage, buttonText: Strings.male);
      },
    );
  }

  Widget _buildFemaleButton() {
    onTap() {
      userDetailBloc.setUserState(1);
    }

    return StreamBuilder(
      stream: userDetailBloc.stateStream,
      builder: (context, snapshot) {
        int state = snapshot.data;
        ///state = 1 - female
        Color color = state == 1 ? Colors.yellow[800] : Colors.white;
        String assetImage = 'assets/images/material/women_icon.png';
        return _buttonBuilder(onTap: onTap, color: color, assetImagePath: assetImage, buttonText: Strings.female);
      },
    );
  }

  Widget _selectAgeButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          child: StreamBuilder(
            stream: userDetailBloc.ageStream,
            builder: (context, snapshot) {

              DateTime dateBirthday = snapshot.data;
              String title = Strings.select_age;

              if(dateBirthday != null ) {
                title = userDetailBloc.calculateAge(dateBirthday);
              }
              return Text(title, style: TextStyle(fontSize: 20),);
            }
          )
        ),
      ),
    );
  }

  _showDateDialog(BuildContext context) async {
    if(Platform.isAndroid) {
      userDetailBloc.selectDate(context)
          .then((DateTime selectedDate) {
            userDetailBloc.setAgeSelected(selectedDate);
      });
    } else {
      _showIosDateBottomDialog(context);
    }
  }

  _showIosDateBottomDialog(BuildContext context) async {
    var date = await showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 260,
          color: Colors.transparent,
          child: IosDialogSelectDate()
        )
    );

    userDetailBloc.setAgeSelected(date);
  }

  Widget _nextButton(BuildContext context) {
    return StreamBuilder(
      stream: userDetailBloc.progressStream,
      initialData: false,
      builder: (context, snapshot) {
        bool isProgressVisible = snapshot.data;
        return isProgressVisible ? _loading() : ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          child: RaisedButton(
            onPressed: () {
              _onButtonNextClick();
            },
            color: Colors.yellow[800],
            textColor: Colors.white,
            child: Text(Strings.next.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        );
      },
    );
  }

  _onButtonNextClick() {
    print("_onButtonNextClick");
    if(state == null) {
      showErrorMessage(Strings.male_error);
      return;
    }

    if(_selectedDate == null) {
      showErrorMessage(Strings.age_error);
      return;
    }

    final newUser = ModalRoute.of(context).settings.arguments as UserModel;

    userDetailBloc.onNextButtonClick(newUser, _selectedDate.millisecondsSinceEpoch, state);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void prepareListeners() {
    userDetailBloc.stateStream.listen((int state) {
      this.state = state;
    });

    userDetailBloc.ageStream.listen((DateTime dateTime) {
      this._selectedDate = dateTime;
    });

    userDetailBloc.userStream.listen((UserModel newUser) {
      print("New user is: ${newUser.name}");
      Navigator.pushReplacementNamed(context, '/mainNavigation', arguments: newUser);
    });

    userDetailBloc.errorStream.listen((onError) {
      showErrorMessage(onError);
    });
  }

  @override
  void dispose() {
    userDetailBloc.logout();
    super.dispose();
  }

  void _arrowBackClicked() {
    userDetailBloc.logout();
    
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context, true);
    });
  }
}
