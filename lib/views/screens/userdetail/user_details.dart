import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/utils/colors.dart';

/*
* Features:
* 1. Open full image.
* 2. Slide Image
*
*
* */
class UserDetails extends StatefulWidget {
  final UserModel user;

  UserDetails({@required this.user});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: CustomColors.mainBackground,
      body: ListView(
        children: <Widget>[
          _userImage()
        ],
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
      color: CustomColors.personItemBackground,
      margin: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[

        ],
      ),
    );
  }

  Widget _userNameAgeRow() {
    return Row(
      children: <Widget>[
        Text("Andrii Chemer, 23", style: TextStyle(color: Colors.white),),
        _goldCircle(),
        _blueCircle()
      ],
    );
  }

  Widget _goldCircle() {
    return Container(
      width: 12,
      height: 12,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          shape: BoxShape.circle
      ),
    );
  }

  Widget _blueCircle() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 12,
        height: 12,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue[800],
            shape: BoxShape.circle
        ),
        child: Center(
          child: Icon(Icons.done, color: Colors.white, size: 10,),
        ),

      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.toolbarBackground,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.yellow[800], width: 1)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _arrowBack(),
              Image.asset("assets/images/logo_big.png",),
              Container(width: 30, height: 30,)
            ],
          ),
        )
      ],
    );
  }

  Widget _arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
    );
  }
}
