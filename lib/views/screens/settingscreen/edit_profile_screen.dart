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

  var _nameController = TextEditingController();
  var _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.user.name;
    _ageController.text = widget.user.calculateAge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.lightBackground,
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
        _carouselImage(context),
        _editName(),
        _editAge(),
        _editLocation(),
      ],
    );
  }

  Widget _editName() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Strings.name, style: TextStyle(color: Colors.yellow[800]),),
          SizedBox(height: 5,),
          TextFormField(
            autofocus: false,
            controller: _nameController,
            style: TextStyle(fontSize: 18.0, color: Colors.yellow[800]),
            decoration: InputDecoration(
                filled: true,
                fillColor: CustomColors.secondaryBackground,
                hintText: Strings.name,
                prefixIcon: Icon(Icons.person, color: Colors.yellow[800],),
                contentPadding: const EdgeInsets.only(left: 25.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _editAge() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Strings.age, style: TextStyle(color: Colors.yellow[800]),),
          SizedBox(height: 5,),
          TextFormField(
            autofocus: false,
            controller: _ageController,
            style: TextStyle(fontSize: 18.0, color: Colors.yellow[800]),
            decoration: InputDecoration(
                filled: true,
                fillColor: CustomColors.secondaryBackground,
                hintText: Strings.age,
                prefixIcon: Icon(Icons.calendar_today, color: Colors.yellow[800],),
                contentPadding: const EdgeInsets.only(left: 25.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _editLocation() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Strings.where_from, style: TextStyle(color: Colors.yellow[800]),),
          SizedBox(height: 5,),
          TextFormField(
            autofocus: false,
            style: TextStyle(fontSize: 18.0, color: Colors.yellow[800]),
            decoration: InputDecoration(
                filled: true,
                fillColor: CustomColors.secondaryBackground,
                hintText: Strings.from_title,
                hintStyle: TextStyle(color: Colors.yellow[800].withOpacity(0.40)),
                prefixIcon: Icon(Icons.location_on, color: Colors.yellow[800],),
                contentPadding: const EdgeInsets.only(left: 25.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                )
            ),
          )
        ],
      ),
    );
  }

  Widget _carouselImage(BuildContext context) {
    return Container(
      height: 270,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          _imageSlider(context),
          _changeImageButton(),
        ],
      ),
    );
  }

  Widget _imageSlider(BuildContext context) {
    return widget.user.isPhotoEmpty() ? _emptyImage(context) : CarouselSlider(
      height: 250,
      items: widget.user.photos.map((photoUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.amber),
              child: GestureDetector(
                child: Image.network(photoUrl, fit: BoxFit.cover,),
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

  Widget _emptyImage(BuildContext context) {
    String image = widget.user.getEmptyPhoto();
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.amber),
      child: GestureDetector(
        child: Image.asset(image, fit: BoxFit.cover,),
        onTap: () {
          //TODO add opening image screen
        },
      ),
    );
  }

  Widget _changeImageButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: 40),
        child: FloatingActionButton(
          backgroundColor: Colors.yellow[800],
          child: Icon(Icons.edit, color: Colors.white,),
        ),
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
