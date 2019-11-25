
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class VerifyMobileNumberScreen extends StatefulWidget {
  @override
  _VerifyMobileNumberScreenState createState() => _VerifyMobileNumberScreenState();
}

class _VerifyMobileNumberScreenState extends State<VerifyMobileNumberScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isProgressLoad = false;

  var firstDigitController = TextEditingController();
  var secondDigitController = TextEditingController();
  var thirdDigitController = TextEditingController();
  var fourthDigitController = TextEditingController();

  var firstFocusNode = FocusNode();
  var secondFocusNode = FocusNode();
  var thirdFocusNode = FocusNode();
  var fourthFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    firstDigitController.addListener((){
      _checkDigits();
      _fieldFocusChange(context, firstFocusNode, secondFocusNode);
    });
    secondDigitController.addListener((){
      if(secondDigitController.text.length == 0) {
        _fieldFocusChange(context, secondFocusNode, firstFocusNode);
      }
      _checkDigits();
      _fieldFocusChange(context, secondFocusNode, thirdFocusNode);

    });
    thirdDigitController.addListener((){
      if(thirdDigitController.text.length == 0) {
        _fieldFocusChange(context, thirdFocusNode, secondFocusNode);
      }
      _checkDigits();
      _fieldFocusChange(context, thirdFocusNode, fourthFocusNode);
    });
    fourthDigitController.addListener((){
      if(fourthDigitController.text.length == 0) {
        _fieldFocusChange(context, fourthFocusNode, thirdFocusNode);
      }
      _checkDigits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.only(top: 40),
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
              ),
              SizedBox(height: 30,),
              Center(child: Text(Strings.verify_mobile_title, style: TextStyle(color: Colors.white, fontSize: 30),),),
              SizedBox(height: 30,),
              Text(Strings.verify_mobile_description, style: TextStyle(color: Colors.white, fontSize: 15),),
              SizedBox(height: 30,),
              _verifyFields(),
              _progressIndicator(),
              _notReceivedCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notReceivedCode() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: (){
            showFeatureNotImplementedYet();
          },
          child: Text(Strings.nave_nor_received_code, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: isProgressLoad ? CircularProgressIndicator(strokeWidth: 7.0, value: null,) : Container(),
      ),
    );
  }

  Flexible _textFormField(TextEditingController controller, FocusNode focusNode) {
    return Flexible(
      child: TextFormField(
        autofocus: true,
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: textFieldInputDecoration(),
      ),
    );
  }

  InputDecoration textFieldInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow[800]),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.yellow[800]),
        borderRadius: BorderRadius.circular(5),
      )
    );
  }

  Form _verifyFields() {
    return Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _textFormField(firstDigitController, firstFocusNode),
          Text("-", style: TextStyle(color: Colors.yellow[800], fontSize: 30),),
          _textFormField(secondDigitController, secondFocusNode),
          Text("-", style: TextStyle(color: Colors.yellow[800], fontSize: 30),),
          _textFormField(thirdDigitController, thirdFocusNode),
          Text("-", style: TextStyle(color: Colors.yellow[800], fontSize: 30),),
          _textFormField(fourthDigitController, fourthFocusNode),
        ],
      ),
    );
  }

  _checkDigits() {
    if(firstDigitController.text.length == 1 &&
       secondDigitController.text.length == 1 &&
       thirdDigitController.text.length == 1 &&
       fourthDigitController.text.length == 1) {
      setState(() {
        isProgressLoad = true;
      });
      emitServerLoader();
//      MockServer.checkVerifyCode("1111").then((bool val){
//        if (val) {
//          openNextScreen();
//        }
//      });
    }
  }

  emitServerLoader() async {
    Timer(Duration(seconds: 3), openNextScreen);
  }

  openNextScreen() {
    setState(() {
      isProgressLoad = false;
    });
    Navigator.pushReplacementNamed(context, '/verifyphone');
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    firstDigitController.dispose();
    secondDigitController.dispose();
    thirdDigitController.dispose();
    fourthDigitController.dispose();
  }

  void showFeatureNotImplementedYet() {
    final snackBar = SnackBar(
      content: Text("This feature not implemented yet!", style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
