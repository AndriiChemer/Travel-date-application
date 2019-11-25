import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class SetPasswordScreen extends StatefulWidget {
  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              arrowBack(),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              Text(Strings.set_password, style: TextStyle(color: Colors.white, fontSize: 35),),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              _passwordTextField(),
              Flexible(
                child: SizedBox(height: 20,),
              ),
              _confirmPasswordTextField(),
              Flexible(
                child: SizedBox(height: 30,),
              ),
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

  Widget _passwordTextField() {
    return TextFormField(
      autofocus: false,
      controller: passwordController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.password,
          prefixIcon: Icon(Icons.lock, color: Colors.grey[800],),
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

  Widget _confirmPasswordTextField() {
    return TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.confirm_password,
          prefixIcon: Icon(Icons.lock, color: Colors.grey[800],),
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

  Widget _nextButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
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
        ),
      ),
    );
  }

  _onButtonNextClick() {
    //TODO open next screen
  }
}
