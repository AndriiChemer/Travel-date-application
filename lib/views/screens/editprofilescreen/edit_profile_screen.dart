import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/user_bloc.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/global_value.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/editimages/edit_images.dart';
import 'package:travel_date_app/views/widgets/CustomTextField.dart';
import 'package:travel_date_app/views/widgets/app_bars.dart';

import 'package:dio/dio.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';


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
  var _locationController = TextEditingController();
  var _describeController = TextEditingController();

  UserRepository _userRepository = UserRepository();
  UserPreferences _userPreferences = UserPreferences();

  UserBloc userBloc;

  @override
  void initState() {
    super.initState();

    SimpleAuthFlutter.init(context);

    userBloc = BlocProvider.getBloc<UserBloc>();
    userBloc.getImageList();

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
      appBar: CustomAppBar(title: Strings.edit_profile_toolbar, backgroundColor: CustomColors.secondaryBackground,),
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

  Widget _buildButton(String iconPath, String buttonText, GestureTapCallback callback) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBackground,
        borderRadius: BorderRadius.all(
            Radius.circular(25)
        ),
      ),
      child: FlatButton(
        onPressed: callback,
        child: Container(
          height: 50,
          padding: EdgeInsets.only(top: 7, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(iconPath),
              ),
              Text(buttonText, style: TextStyle(fontSize: 20, color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _instagramButton(BuildContext context) {
    var iconPath = 'assets/images/icons/instagram_logo.png';

    return _buildButton(iconPath, Strings.conn_instagram, _onInstagramButtonClicked);
  }

  Widget _snapchatButton(BuildContext context) {
    var iconPath = 'assets/images/icons/snapchat_logo.png';
    return _buildButton(iconPath, Strings.conn_snapchat, () {

    });
  }

  Widget _editName() {
    return CustomTextField(name: Strings.name, controller: _nameController, iconData: Icons.person);
  }

  Widget _editAge() {
    return CustomTextField(name: Strings.age, controller: _ageController, iconData: Icons.calendar_today);
  }

  Widget _editLocation() {
    return CustomTextField(name: Strings.where_from, controller: _locationController, iconData: Icons.location_on);
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
    return widget.user.isPhotoEmpty() ? _emptyImage(context) :
    StreamBuilder<Object>(
      stream: userBloc.imageListStream,
      initialData: widget.user.images,
      builder: (context, snapshot) {

        List<String> images = snapshot.data as List<String>;

        return CarouselSlider(
          height: 250,
          viewportFraction: 1.0,
          items: images.map((photoUrl) {
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
            bool isUpdate = result['isUpdate'] as bool;
            if(isUpdate) {
              print('isUpdate = $isUpdate');
              userBloc.getImageList();
            }
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
      print('onSaveButtonClick');
      _userRepository.updateUser(widget.user);
      Navigator.of(context).pop({'isUpdate' : true});
    }
  }




  final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
    "instagram",
    GlobalValue.appID,
    GlobalValue.secretID,
    GlobalValue.redirectUrl,
    scopes: [
      'user_profile', // For getting username, account type, etc.
      'user_media', // For accessing media count & data like posts, videos etc.
    ],
  );

  _onInstagramButtonClicked() {

    _igApi.authenticate().then((simpleAuth.Account _user) async {
      print('result');
      simpleAuth.OAuthAccount user = _user;
      var igUserResponse =
          await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
            '/me',
            queryParameters: {
              "fields": "username,id,account_type,media_count",
              "access_token": user.token,
            }
          );

      print("data1: ${igUserResponse.data['id']}");
      print("data2: ${igUserResponse.data['username']}");
      print("data3: ${igUserResponse.data['account_type']}");
      print("data4: ${igUserResponse.data['media_count']}");

    });
  }
}
