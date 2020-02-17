import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/editimages/edit_images.dart';

class EditProfileScreen extends StatefulWidget {

  UserModel user;

  EditProfileScreen({@required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _nameController = TextEditingController();
  var _ageController = TextEditingController();
  var _locationController = TextEditingController();
  var _describeController = TextEditingController();

  UserRepository _userRepository = UserRepository();
  UserPreferences _userPreferences = UserPreferences();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.user.name;
    _ageController.text = widget.user.calculateAge();
    _locationController.text = widget.user.city;
    _describeController.text = widget.user.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _describeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(context),
      backgroundColor: CustomColors.lightBackground,
      body: Stack(
        children: <Widget>[
          _mainContent(context),
          _notVerifyRow(context)
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.secondaryBackground,
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
              Text(Strings.edit_profile_toolbar, style: TextStyle(color: Colors.white, fontSize: 20),),
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

  Widget _mainContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        _carouselImage(context),
        _editName(),
        _editAge(),
        _editLocation(),
        _editDescription(),
        _instagramButton(context),
        _snapchatButton(context),
        _saveButton(context)
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, widget.user.isVerify ? 20 : 40),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
        child: RaisedButton(
          color: Colors.yellow[800],
          textColor: Colors.white,
          child: Text(Strings.save_button.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
          onPressed: onSaveButtonClick,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Widget _instagramButton(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackground,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 10),
              child: Image.asset('assets/images/icons/instagram_logo.png'),
            ),
            Text(Strings.conn_instagram, style: TextStyle(fontSize: 20, color: Colors.white),)
          ],
        ),
      ),
    );
  }

  Widget _snapchatButton(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 20,),
        decoration: BoxDecoration(
          color: CustomColors.secondaryBackground,
          borderRadius: BorderRadius.all(
              Radius.circular(25)
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 10),
              child: Image.asset('assets/images/icons/snapchat_logo.png'),
            ),
            Text(Strings.conn_snapchat, style: TextStyle(fontSize: 20, color: Colors.white),)
          ],
        ),
      ),
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
                hintStyle: TextStyle(color: Colors.yellow[800].withOpacity(0.40)),
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
                hintStyle: TextStyle(color: Colors.yellow[800].withOpacity(0.40)),
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
            controller: _locationController,
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

  Widget _editDescription() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(Strings.describe_yourself, style: TextStyle(color: Colors.yellow[800]),),
          SizedBox(height: 5,),
          TextFormField(
            autofocus: false,
            style: TextStyle(fontSize: 18.0, color: Colors.yellow[800]),
            maxLines: 7,
            controller: _describeController,
            decoration: InputDecoration(
                filled: true,
                fillColor: CustomColors.secondaryBackground,
                hintText: Strings.few_words,
                hintStyle: TextStyle(color: Colors.yellow[800].withOpacity(0.40)),
                prefixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 125.0),
                  child: Icon(Icons.event_note, color: Colors.yellow[800],),
                ),
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
      items: widget.user.images.map((photoUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
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
      height: 250,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          )
      ),
      child: GestureDetector(
        child: Image.asset(image, fit: BoxFit.cover,),
        onTap: () {
          //TODO task add opening image screen
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
          onPressed: () async {
            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditImageScreen(user: widget.user)));
            setState(() {
              widget.user = result['user'] as UserModel;
            });
          },
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

  onSaveButtonClick() {
    String name = _nameController.text;
    String city = _locationController.text;
    String description = _describeController.text;

    if(name.isNotEmpty && name.length > 2) {
      widget.user.name = name;
    }

    if(city.isNotEmpty && city.length > 2) {
      widget.user.city = city;
    }

    if(description.isNotEmpty && description.length > 2) {
      widget.user.description = description;
    }

    if((name.isNotEmpty && name.length > 2) &&
        (city.isNotEmpty && city.length > 2) &&
        (description.isNotEmpty && description.length > 2)) {
      _userPreferences.writeUser(widget.user);
      _userRepository.updateUser(widget.user);
      Navigator.pop(context);
    }
  }
}
