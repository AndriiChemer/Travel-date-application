import 'package:shared_preferences/shared_preferences.dart';

class SettingPreferences {

  String notificationMessage = "notificationMessage";
  String notificationLikes = "notificationLikes";
  String notificationProfileViews = "notificationProfileViews";
  String vibration = "vibration";
  String sound = "sound";
  String hideProfile = "hideProfile";

  SharedPreferences prefs;

  Future<SettingPreferences> initPreferences() async {
    prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ___________________________Push Notification_______________________________

  // Messages___________________________________________________________________
  setNotificationMessage(bool value) {
    prefs.setBool(notificationMessage, value);
  }

  bool getNotificationMessage() {
    bool isCheck = prefs.getBool(notificationMessage);
    return isCheck == null || isCheck == false ? false : true;
  }

  // Likes______________________________________________________________________
  setNotificationLikes(bool value) {
    prefs.setBool(notificationLikes, value);
  }

  bool getNotificationLikes() {
    bool isCheck = prefs.getBool(notificationLikes);
    return isCheck == null || isCheck == false ? false : true;
  }

  // Profile views______________________________________________________________
  setNotificationProfileViews(bool value) {
    prefs.setBool(notificationProfileViews, value);
  }

  bool getNotificationProfileViews() {
    bool isCheck = prefs.getBool(notificationProfileViews);
    return isCheck == null || isCheck == false ? false : true;
  }



  // _________________________________Others____________________________________

  // Vibration__________________________________________________________________
  setOthersVibrations(bool value) {
    prefs.setBool(vibration, value);
  }

  bool getOthersVibrations() {
    bool isCheck = prefs.getBool(vibration);
    return isCheck == null || isCheck == false ? false : true;
  }

  // Sound______________________________________________________________________
  setOthersSound(bool value) {
    prefs.setBool(sound, value);
  }

  bool getOthersSound() {
    bool isCheck = prefs.getBool(sound);
    return isCheck == null || isCheck == false ? false : true;
  }

  // Hide profile_______________________________________________________________
  setHideProfile(bool value) {
    prefs.setBool(hideProfile, value);
  }

  bool getHideProfile() {
    bool isCheck = prefs.getBool(hideProfile);
    return isCheck == null || isCheck == false ? false : true;
  }
}