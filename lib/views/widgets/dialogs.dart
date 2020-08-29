import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/widgets/text_field.dart';

class GeneralDialogs extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  GeneralDialogs({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 66.0 + 16.0,
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          margin: EdgeInsets.only(top: 66.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


class ResetPasswordDialogs extends StatelessWidget {
  final String title, description;
  final Image image;

  final emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ResetPasswordDialogs({
    @required this.title,
    @required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                _getTitle(),
                SizedBox(height: 16.0),
                _getMessage(),
                SizedBox(height: 24.0),
                _getTextField(),
                SizedBox(height: 24.0),
                Divider(),
                _buttons(context)
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _getTitle() {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _getMessage() {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.0,
      ),
    );
  }

  Widget _getTextField() {
    return TextFormField(
      autofocus: false,
      validator: ValidateFields.isEmailValid,
      controller: emailController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: getItemDecorationForField(hintText: Strings.email, iconData: Icons.person),
    );
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            var email = emailController.value.text;
            if(EmailValidator.validate(email.toString())) {
              Navigator.pop(context, email);
            } if(email == '') {
              Navigator.pop(context, null);
            }
          },
          child: Text(Strings.ok, style: TextStyle(fontSize: 16),),
        ),
        Divider(),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, null);//of(context).pop(); // To close the dialog
          },
          child: Text(Strings.cancel, style: TextStyle(fontSize: 16),),
        )
      ],
    );
  }

  _onOkButtonPressed() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("Valid");
    } else {
      print("Else");
    }
  }
}
