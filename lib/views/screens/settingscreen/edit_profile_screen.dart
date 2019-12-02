import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';

class EditProfileScreen extends StatefulWidget {

  final UserModel user;

  EditProfileScreen({@required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mainBackground,
      body: Stack(
        children: <Widget>[
          _notVerifyRow(context)
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        _carouselImage(context)
      ],
    );
  }

  Widget _carouselImage(BuildContext context) {
    return Container(
      height: 270,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _changeImageButton(),
          _imageSlider(context)
        ],
      ),
    );
  }

  Widget _imageSlider(BuildContext context) {
    return CarouselSlider(
      height: 250,
      items: widget.user.photos.map((photoUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.amber),
              child: GestureDetector(
                child: Image.network(photoUrl, fit: BoxFit.contain,),
                onTap: () {
                  //TODO add opening image screen
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _changeImageButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Icon(Icons.edit, color: Colors.white,),
      ),
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
}
