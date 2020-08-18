
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/repository/auth_repository.dart';

class SetUserDetails extends StatefulWidget {
  @override
  _SetUserDetailsState createState() => _SetUserDetailsState();
}

class _SetUserDetailsState extends State<SetUserDetails> {

  Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Center(
        child: FloatingActionButton(
          heroTag: "logout",
          backgroundColor: Colors.white,
          child: Icon(Icons.exit_to_app),
          onPressed: onLogoutClick,
        ),
      ),
    );
  }

  void onLogoutClick() {
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (Route<dynamic> route) => false);
  }
}
