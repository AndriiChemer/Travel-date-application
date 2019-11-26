import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/screens/registrationflow/verifymobilenumber/verifynumber.dart';
import 'package:travel_date_app/views/widgets/country_picker.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  CountryCode _selectedCountry;
  bool isTermsChecked = false;

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.only(left: 30, right: 30, top: 100),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(Strings.sing_up, style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),),
                Flexible(child: SizedBox(height: 60,),),
                _nameInputField(),
                Flexible(child: SizedBox(height: 20,),),
                _emailInputField(),
                Flexible(child: SizedBox(height: 20,),),
                _phoneInputField(),
                Flexible(child: SizedBox(height: 20,),),
                _termsCheckBox(context),
                SizedBox(height: 30,),
                _buttonSingUp(context),
                Flexible(child: SizedBox(height: 40,),),
                Center(child: Text(Strings.or.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),),
                Flexible(child: SizedBox(height: 40,),),
                _socialMedias(),
                Flexible(child: SizedBox(height: 40,),),
                _singInButton(),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _nameInputField() {
    return TextFormField(
      autofocus: false,
      validator: ValidateFields.isNameValid,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.name,
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

  Widget _emailInputField() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: ValidateFields.isEmailValid,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.email,
          prefixIcon: Icon(Icons.email, color: Colors.grey[800],),
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

  Widget _phoneInputField() {
    return Row(
      children: <Widget>[
        _selectCountry(),
        SizedBox(width: 10,),
        Flexible(
          child: TextFormField(
            autofocus: false,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            validator: ValidateFields.isPhoneValid,
            style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: Strings.phone_number,
                prefixIcon: Icon(Icons.phone_iphone, color: Colors.grey[800],),
                contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.7), topRight: Radius.circular(25.7)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(25.7), topRight: Radius.circular(25.7)),
                )
            ),
          ),
        )
      ],
    );
  }

  Widget _termsCheckBox(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: isTermsChecked,
              checkColor: Colors.grey[800],
              activeColor: Colors.white,
              onChanged: (bool value) {
                setState(() {
                  isTermsChecked = value;
                });
              },
            ),
          ),

          Flexible(child: RichText(
            maxLines: 2,
            text: TextSpan(
                text: Strings.i_agree,
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(
                      text: Strings.terms_service,
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showCustomBottomSheetDialog(context, Strings.terms_service);
                        }
                  ),
                  TextSpan(
                    text: Strings.and_,
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                      text: Strings.privacy_policy,
                      style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showCustomBottomSheetDialog(context, Strings.privacy_policy);
                        }
                  ),
                ]
            ),
          ),),
        ],
      ),
    );
  }

  Widget _buttonSingUp(BuildContext context) {
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      child: RaisedButton(
        color: Colors.yellow[800],
        textColor: Colors.white,
        child: Text(Strings.sing_up.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
        onPressed: () {
          _validateInputs();
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _socialMedias() {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "facebook",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/facebook.png"),
            onPressed: (){
              showFeatureNotImplementedYet();
            },
          ),

          FloatingActionButton(
            heroTag: "google-plus",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/google-plus.png"),
            onPressed: (){
              showFeatureNotImplementedYet();
            },
          ),

          FloatingActionButton(
            heroTag: "instagram",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/instagram.png"),
            onPressed: (){
              showFeatureNotImplementedYet();
            },
          ),

          FloatingActionButton(
            heroTag: "snapchat-ghost",
            backgroundColor: Colors.white,
            child: Image.asset("assets/images/socialmedia/snapchat-ghost.png"),
            onPressed: (){
              showFeatureNotImplementedYet();
            },
          )
        ],
      ),
    );
  }

  Widget _singInButton() {
    return Center(
      child: RichText(
        text: TextSpan(
            text: Strings.already_have_account,
            style: TextStyle(color: Colors.white, fontSize: 17),
            children: [
              TextSpan(
                  text: Strings.sing_in,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showFeatureNotImplementedYet();
                    }
              ),
            ]
        ),
      ),
    );
  }

  showCustomBottomSheetDialog(BuildContext context, String textContent) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 250,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),

            ),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(textContent),
            )
          ),
        )
    );
  }

  void showFeatureNotImplementedYet() {
    final snackBar = SnackBar(
      content: Text("This feature not implemented yet!", style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _selectCountry() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25.7), bottomLeft: Radius.circular(25.7))
      ),
      child: CountryPicker(
        onChanged: _onCountryChange,
        showFlag: false,
        initialSelection: 'PL',
        favorite: ['+48','PL'],
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        isOnlyCode: true,
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _selectedCountry = countryCode;
    });
  }

  void _validateInputs() {
    if (_formKey.currentState.validate() && isTermsChecked) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyMobileNumberScreen()));
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
