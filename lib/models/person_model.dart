
import 'package:intl/intl.dart';

class UserModel {
  // DateFormat("dd/MM/yyyy HH:mm:ss").parse("10/02/2000 15:13:09")
  // String, description
  // List<String> photos
  final int id;
  final String name;
  final String city;
  final String imageUrl;
  final int state;
  final String status;
  final String dateCreated;
  final String lastTimeOnline;
  final double lat;
  final double lng;
  final String person;
  final String description;
  final bool isVerify;

  List<String> photos = [];
  String birthday = "31/12/1995";

  UserModel({this.id, this.name, this.city, this.imageUrl, this.state,
    this.status, this.dateCreated, this.lastTimeOnline, this.lat, this.lng,
  this.person, this.description, this.isVerify});

  String calculateAge() {
    DateTime birthDate = DateFormat("dd/MM/yyyy").parse(birthday);
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;
    int currentMonth = currentDate.month;
    int birthMonth = birthDate.month;

    if (birthMonth > currentMonth) {
      age--;
    } else if (currentMonth == birthMonth) {
      int currentDay = currentDate.day;
      int birthDay = birthDate.day;
      if (birthDay > currentDay) {
        age--;
      }
    }
    return age.toString();
  }

  bool isPhotoEmpty() {
    if(photos.length == 0 && imageUrl == null) {
      return true;
    } else {
      buildPhotoList();
      return false;
    }

  }

  void buildPhotoList() {
    if(imageUrl != null) {
      photos.insert(0, imageUrl);
    }
  }

  String getEmptyPhoto() {
    if(state == 0) {
      return "assets/images/no_image_male.jpg";
    } else {
      return "assets/images/no_image_female.jpg";
    }
  }
}