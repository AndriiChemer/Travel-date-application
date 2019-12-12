
import 'package:intl/intl.dart';

class UserModel {
  // DateFormat("dd/MM/yyyy HH:mm:ss").parse("10/02/2000 15:13:09")
  // String, description
  // List<String> photos
  String id;
  String name;
  String city;
  String imageUrl;
  String phone;
  String country;
  String countryCode;
  int state;
  String status;
  int dateCreated;
  int lastTimeOnline;
  double lat;
  double lng;
  String sex;
  String description;
  String email;
  String password;
  bool isVerify;
  bool isHide;
  bool isOnline;
  int createdAt;
  int lastVisitedAt;
  int birthday;

  List<String> photos = [];

  UserModel({this.id = '', this.name = '', this.city = '', this.imageUrl = '', this.state = -1,
    this.status = '', this.dateCreated = -1, this.lastTimeOnline = -1, this.lat = 0.0, this.lng = 0.0,
    this.sex = '', this.description = '', this.isVerify = false, this.isHide = false, this.isOnline = false,
    this.createdAt = -1, this.lastVisitedAt = -1, this.birthday = -1, this.email = '', this.password = '',
    this.phone = '', this.country = '', this.countryCode = ''});


  UserModel.fromMap(Map snapshot, String id) :
        id = id ?? '',
        name = snapshot['name'] ?? '',
        city = snapshot['city'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        state = snapshot['state'] ?? -1,
        status = snapshot['status'] ?? '',
        dateCreated = snapshot['dateCreated'] ?? 0,
        lastTimeOnline = snapshot['lastTimeOnline'] ?? 0.0,
        lat = snapshot['lat'] ?? 0.0,
        lng = snapshot['lng'] ?? 0.0,
        sex = snapshot['sex'] ?? '',
        description = snapshot['description'] ?? '',
        isVerify = snapshot['isVerify'] ?? false,
        isHide = snapshot['lng'] ?? false,
        isOnline = snapshot['lng'] ?? false,
        createdAt = snapshot['createdAt'] ?? 0.0,
        lastVisitedAt = snapshot['lastVisitedAt'] ?? 0.0,
        birthday = snapshot['birthday'] ?? 0.0,
        email = snapshot['email'] ?? '',
        password = snapshot['password'] ?? '',
        phone = snapshot['phone'] ?? '',
        country = snapshot['country'] ?? '',
        countryCode = snapshot['countryCode'] ?? '';

  toJson() {
    return {
      "name": name,
      "city": city,
      "imageUrl": imageUrl,
      "state": state,
      "status": status,
      "dateCreated": dateCreated,
      "lastTimeOnline": lastTimeOnline,
      "lat": lat,
      "lng": lng,
      "sex": sex,
      "description": description,
      "isVerify": isVerify,
      "isHide": isHide,
      "isOnline": isOnline,
      "createdAt": createdAt,
      "lastVisitedAt": lastVisitedAt,
      "birthday": birthday,
      "email": email,
      "password": password,
      "phone": phone,
      "country": country,
      "countryCode": countryCode,
    };
  }

  //============================================================================
  String calculateAge() {
    var birthDate = DateTime.fromMillisecondsSinceEpoch(birthday);

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