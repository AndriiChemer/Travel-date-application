
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/settings_preferences.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/app_bars.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SettingPreferences _preferences = SettingPreferences();

  bool messageNotification = true;
  bool likesNotification = true;
  bool profileViews = true;

  bool appVibration = true;
  bool appSound = true;
  bool hideProfile = true;

  @override
  void initState() {
    _preferences.initPreferences().then((prefs) {
      setState(() {
        messageNotification = prefs.getNotificationMessage();
        likesNotification = prefs.getNotificationLikes();
        profileViews = prefs.getNotificationProfileViews();
        appVibration = prefs.getOthersVibrations();
        appSound = prefs.getOthersSound();
        hideProfile = prefs.getHideProfile();
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: Strings.settings_toolbar, backgroundColor: CustomColors.secondaryBackground,),
      backgroundColor: CustomColors.lightBackground,
      body: ListView(
        children: <Widget>[
          _titleSection(context, Strings.push_notif_title),
          _optionSection(context, Strings.messages, messageNotification, messageNotificationEvent),
          _optionSection(context, Strings.likes, likesNotification, likeNotificationEvent),
          _optionSection(context, Strings.profile_views, profileViews, profileViewsEvent),

          _titleSection(context, Strings.other),
          _optionSection(context, Strings.app_vibration, appVibration, appVibrationEvent),
          _optionSection(context, Strings.app_sound, appSound, appSoundEvent),
          _optionSection(context, Strings.hide_profile, hideProfile, hideProfileEvent),
          _deleteButton()
        ],
      ),
    );
  }

  Widget _titleSection(BuildContext context, String title) {
    return Container(
      height: 50,
      color: CustomColors.secondaryBackground,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 7),
      child: Center(
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
    );
  }

  Widget _optionSection(BuildContext context, String title, bool isCheck, ValueChanged<bool> onChanged) {
    return Container(
      height: 50,
      color: CustomColors.secondaryBackground,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 3),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white, fontSize: 17),),
          Switch(
            value: isCheck,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        height: 50,
        color: CustomColors.secondaryBackground,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 7),
        child: Center(
          child: Text(Strings.delete_account, style: TextStyle(color: Colors.yellow[800], fontSize: 18),),
        ),
      ),
    );
  }

  messageNotificationEvent(bool isCheck) {
    setState(() {
      messageNotification = isCheck;
      print("messageNotification = $isCheck");
    });
  }

  likeNotificationEvent(bool isCheck) {
    setState(() {
      likesNotification = isCheck;
      _preferences.setNotificationLikes(isCheck);
      print("likeNotificationEvent = $isCheck");
    });
  }

  profileViewsEvent(bool isCheck) {
    setState(() {
      profileViews = isCheck;
      _preferences.setNotificationProfileViews(isCheck);
      print("profileViewsEvent = $isCheck");
    });
  }

  appVibrationEvent(bool isCheck) {
    setState(() {
      appVibration = isCheck;
      _preferences.setOthersVibrations(isCheck);
      print("appVibrationEvent = $isCheck");
    });
  }

  appSoundEvent(bool isCheck) {
    setState(() {
      appSound = isCheck;
      _preferences.setOthersSound(isCheck);
      print("appSoundEvent = $isCheck");
    });
  }

  hideProfileEvent(bool isCheck) {
    setState(() {
      hideProfile = isCheck;
      _preferences.setHideProfile(isCheck);
      print("hideProfileEvent = $isCheck");
    });
  }
}
