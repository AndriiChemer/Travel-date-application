import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';

class AccountScreen extends StatefulWidget {

  final UserModel user;

  AccountScreen({@required this.user});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mainBackground,
      body: Stack(
        children: <Widget>[
          _mainContent(context),
          _notVerifyRow(context)
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        _userImage(),
        _userInformation(),
        _userDescription(),
        _buttonPremiumCenter(context),
        _editProfileButton(),
        SizedBox(height: 3,),
        _verifyProfileButton(),
        SizedBox(height: widget.user.isVerify ? 0 : 3,),
        _settingsProfileButton(),
        SizedBox(height: 3,),
        _signOutButton(),
        SizedBox(height: widget.user.isVerify ? 20 : 40,),
      ],
    );
  }

  Widget _notVerifyRow(BuildContext context) {
    return widget.user.isVerify ? Container() : Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(3),
        color: Colors.yellow[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline, color: Colors.black,),
            SizedBox(width: 10,),
            Text(Strings.not_verified, style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    );
  }

  Widget _buttonPremiumCenter(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
        child: RaisedButton(
          color: Colors.yellow[800],
          textColor: Colors.white,
          child: Text(Strings.premium_center.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
          onPressed: () {

          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Widget _userImage() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.user.imageUrl),
              fit: BoxFit.cover,
            )
        ),
      ),
    );
  }

  Widget _userInformation() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Text("Andrii Chemer, 23", style: TextStyle(color: Colors.white, fontSize: 23),),
          _goldCircle(),
        ],
      ),
    );
  }

  Widget _goldCircle() {
    return Container(
      width: 18,
      height: 18,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          shape: BoxShape.circle
      ),
    );
  }

  Widget _userDescription() {
    return widget.user.description != null ? Container(
      color: CustomColors.personItemBackground,
      padding: EdgeInsets.all(20),
      child: Text(widget.user.description != null ? widget.user.description : "", style: TextStyle(color: Colors.white),),
    ) : Container();
  }

  Widget _editProfileButton() {
    return _buildButton(Icon(Icons.edit, size: 30, color: Colors.white,), Strings.edit, () {

    });
  }

  Widget _verifyProfileButton() {
    return widget.user.isVerify ? Container() : _buildButton(Icon(Icons.verified_user, size: 30, color: Colors.white,), Strings.verify, () {

    });
  }

  Widget _settingsProfileButton() {
    return _buildButton(Icon(Icons.settings, size: 30, color: Colors.white,), Strings.settings, () {

    });
  }

  Widget _signOutButton() {
    return _buildButton(Icon(Icons.exit_to_app, size: 30, color: Colors.white,), Strings.sign_out, () {

    });
  }

  Widget _buildButton(Widget icon, String buttonText, GestureTapCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
        ),

        child: Container(
          padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(width: 10,),
              Text(buttonText, style: TextStyle(color: Colors.white, fontSize: 20),)
            ],
          ),
        ),
      ),
    );

  }
}
