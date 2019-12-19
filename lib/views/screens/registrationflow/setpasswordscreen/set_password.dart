import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/screens/mainscreen/main_navigation.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class SetPasswordScreen extends StatefulWidget {

  final UserModel newUser;

  SetPasswordScreen({this.newUser});

  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Auth _auth = Auth();
  UserPreferences userPreferences = UserPreferences();
  UserRepository userRepository = UserRepository();

  bool _autoValidate = false;
  bool isLoading = false;

  var passwordController = TextEditingController();

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
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
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
      keyboardType: TextInputType.visiblePassword,
      controller: passwordController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      validator: ValidateFields.isPasswordValid,
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
      keyboardType: TextInputType.visiblePassword,
      validator: validateConfirmPassword,
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

  String validateConfirmPassword(String confirmPassword) {
    if(confirmPassword == passwordController.text) {
      return null;
    } else {
      return "Enter the correct password";
    }
  }

  _onButtonNextClick() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = true;
      });

      widget.newUser.password = passwordController.text;
      widget.newUser.isOnline = true;
      widget.newUser.dateCreated = DateTime.now().millisecondsSinceEpoch * 1000;

      _auth.signUp(widget.newUser.email, widget.newUser.password).then((firebaseUser) {

        widget.newUser.id = firebaseUser.uid;

        userPreferences.writeUser(widget.newUser);
        userRepository.addNewUser(widget.newUser).then((value) {
          print("Successfully creating user in remote Database");
          print(value.toString());

          if(value) {
            setState(() {
              isLoading = false;
            });

            //TODO task clean stack screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => MainNavigation()));
          } else {
            isLoading = false;
            // TODO task show error
          }
        });

      }).catchError((error) {
        print("onError");
        print(error.toString());
        var errorModel = error as PlatformException;
        print(errorModel.message);
        print(errorModel.code);
        // TODO task show error
        setState(() {
          isLoading = false;
        });
      });

    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }
}
