import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_date_app/models/person_model.dart';

class UserPreferences {
  SharedPreferences prefs;

  Future<bool> isLoggedIn() async {
    prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool("isLoggedIn");
    if(isLoggedIn == null) {
      return false;
    }

    return isLoggedIn;
  }

  saveLoggedIn() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", true);
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setBool("isLoggedIn", false);
  }

  writeUser(UserModel user) async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('city', user.city);
    await prefs.setString('imageUrl', user.imageUrl);
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
  }

  Future<UserModel> getUser() async {
    prefs = await SharedPreferences.getInstance();

    String id = prefs.getString('id');
    String name = prefs.getString('name');
    String city = prefs.getString('city');
    String imageUrl = prefs.getString('imageUrl');
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

    var user = UserModel(id: id, name: name, city: city, imageUrl: imageUrl,
        status: status, sex: sex, description: description, dateCreated: dateCreated,
        lastVisitedAt: lastVisitedAt, birthday: birthday, lat: lat, lng: lng, isVerify: isVerify,
        isHide: isHide, isOnline: isOnline, email: email, password: password);

    return user;
  }

  setUserImage(String imageUrl) async {
    prefs = await SharedPreferences.getInstance();

    await prefs.setString('imageUrl', imageUrl);
  }

  Future<String> getUserId() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getString('id');
  }

  void addGalleryImage(String imageUrl) async {
    prefs = await SharedPreferences.getInstance();

    List<String> images = prefs.getStringList("images");
    images.add(imageUrl);

    await prefs.setStringList("images", images);
  }

  Future<List<String>> getGalleryImages() async {
    prefs = await SharedPreferences.getInstance();

    return prefs.getStringList("images");
  }
}