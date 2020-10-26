import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_date_app/models/user_model.dart';

class UserPreferences {
  SharedPreferences prefs;

  static const String _userID = 'id';
  static const String _userImage = 'imageUrl';
  static const String _isLoggedIn = 'isLoggedIn';
  static const String _imageList = 'imageList';

  Future<bool> logout() async {
    prefs = await SharedPreferences.getInstance();
    _removeUser(prefs);

    await prefs.setBool(_isLoggedIn, false);
    return true;
  }

  Future<bool> isLoggedIn() async {
    prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool(_isLoggedIn);
    if(isLoggedIn == null) {
      return false;
    }

    return isLoggedIn;
  }

  saveLoggedIn() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedIn, true);
  }

  writeUser(UserModel user) async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userID, user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('city', user.city);
    await prefs.setString(_userImage, user.imageUrl);
    await prefs.setString('status', user.status);
    await prefs.setString('sex', user.sex);
    await prefs.setString('description', user.description);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
    await prefs.setInt('dateCreated', user.dateCreated);
    await prefs.setInt('lastVisitedAt', user.lastVisitedAt);
    await prefs.setInt('birthday', user.birthday);
    await prefs.setDouble('lat', user.lat);
    await prefs.setDouble('lng', user.lng);
    await prefs.setBool('isVerify', user.isVerify);
    await prefs.setBool('isHide', user.isHide);
    await prefs.setBool('isOnline', user.isOnline);
    await prefs.setStringList(_imageList, user.images);
  }

  Future<UserModel> getUser() async {
    prefs = await SharedPreferences.getInstance();

    String id = prefs.getString(_userID);
    String name = prefs.getString('name');
    String city = prefs.getString('city');
    String imageUrl = prefs.getString(_userImage);
    String status = prefs.getString('status');
    String sex = prefs.getString('sex');
    String description = prefs.getString('description');
    String email = prefs.getString('email');
    String password = prefs.getString('password');
    int dateCreated = prefs.getInt('dateCreated');
    int lastVisitedAt = prefs.getInt('lastVisitedAt');
    int birthday = prefs.getInt('birthday');
    double lat = prefs.getDouble('lat');
    double lng = prefs.getDouble('lng');
    bool isVerify = prefs.getBool('isVerify');
    bool isHide = prefs.getBool('isHide');
    bool isOnline = prefs.getBool('isOnline');
    List<String> images = prefs.getStringList(_imageList);

    var user = UserModel(id: id, name: name, city: city, imageUrl: imageUrl,
        status: status, sex: sex, description: description, dateCreated: dateCreated,
        lastVisitedAt: lastVisitedAt, birthday: birthday, lat: lat, lng: lng, isVerify: isVerify,
        isHide: isHide, isOnline: isOnline, email: email, password: password, images: images);

    return user;
  }

  setUserImage(String imageUrl) async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userImage, imageUrl);
  }

  Future<String> getUserId() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userID);
  }

  void addGalleryImage(String imageUrl) async {
    prefs = await SharedPreferences.getInstance();

    List<String> images = prefs.getStringList(_imageList);
    if(images != null) {
      images.add(imageUrl);
    } else {
      images = [imageUrl];
    }

    await prefs.setStringList(_imageList, images);
  }

  Future<List<String>> getGalleryImages() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_imageList);
  }

  void _removeUser(SharedPreferences prefs) {
    prefs.setString(_userID, null);
    prefs.setString('name', null);
    prefs.setString('city', null);
    prefs.setString(_userImage, null);
    prefs.setString('status', null);
    prefs.setString('sex', null);
    prefs.setString('description', null);
    prefs.setString('email', null);
    prefs.setString('password', null);
    prefs.setInt('dateCreated', null);
    prefs.setInt('lastVisitedAt', null);
    prefs.setInt('birthday', null);
    prefs.setDouble('lat', null);
    prefs.setDouble('lng', null);
    prefs.setBool('isVerify', null);
    prefs.setBool('isHide', null);
    prefs.setBool('isOnline', null);
    prefs.setStringList(_imageList, null);
  }
}