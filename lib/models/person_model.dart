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
  String status;
  int dateCreated;
  double lat;
  double lng;
  String sex;
  String description;
  String email;
  String password;
  bool isVerify;
  bool isHide;
  bool isOnline;
  int lastVisitedAt;
  int birthday;

  List<String> images = [];

  UserModel({this.id = '', this.name = '', this.city = '', this.imageUrl = '',
    this.status = '', this.dateCreated = -1, this.lat = -1.0,
    this.lng = -1.0, this.sex = '', this.description = '', this.isVerify = false, this.isHide = false,
    this.isOnline = false, this.lastVisitedAt = -1, this.birthday = -1, this.email = '', this.password = '',
    this.phone = '', this.country = '', this.countryCode = '', this.images});


  UserModel.fromMap(Map snapshot) :
        id = snapshot['id'] ?? '',
        name = snapshot['name'] ?? '',
        city = snapshot['city'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        status = snapshot['status'] ?? '',
        dateCreated = snapshot['dateCreated'] as int ?? 0,
        lat = snapshot['lat'] as double ?? 0.0,
        lng = snapshot['lng'] as double ?? 0.0,
        sex = snapshot['sex'] ?? '',
        description = snapshot['description'] ?? '',
        isVerify = snapshot['isVerify'] as bool ?? false,
        isHide = snapshot['isHide'] as bool ?? false,
        isOnline = snapshot['isOnline'] as bool ?? false,
        lastVisitedAt = snapshot['lastVisitedAt'] as int ?? 0,
        birthday = snapshot['birthday'] as int ?? 0,
        email = snapshot['email'] ?? '',
        password = snapshot['password'] ?? '',
        phone = snapshot['phone'] ?? '',
        country = snapshot['country'] ?? '',
        images = snapshot['images'] == null ? [] : List.from(snapshot['images']),
        countryCode = snapshot['countryCode'] ?? '';

//  UserModel.fromMap1(Map snapshot) {
//    id = snapshot['id'] ?? '';
//    name = snapshot['name'] ?? '';
//    city = snapshot['city'] ?? '';
//    imageUrl = snapshot['imageUrl'] ?? '';
//    state = snapshot['state'] as int ?? -1;
//    status = snapshot['status'] ?? '';
//    dateCreated = snapshot['dateCreated'] as int ?? 0;
//    lastTimeOnline = snapshot['lastTimeOnline'] as int ?? 0;
//    lat = snapshot['lat'] as double ?? 0.0;
//    lng = snapshot['lng'] as double ?? 0.0;
//    sex = snapshot['sex'] ?? '';
//    description = snapshot['description'] ?? '';
//    isVerify = snapshot['isVerify'] as bool ?? false;
//    isHide = snapshot['isHide'] as bool ?? false;
//    isOnline = snapshot['isOnline'] as bool ?? false;
//    createdAt = snapshot['createdAt'] as int ?? 0;
//    lastVisitedAt = snapshot['lastVisitedAt'] as int ?? 0;
//    birthday = snapshot['birthday'] as int ?? 0;
//    email = snapshot['email'] ?? '';
//    password = snapshot['password'] ?? '';
//    phone = snapshot['phone'] ?? '';
//    country = snapshot['country'] ?? '';
//    countryCode = snapshot['countryCode'] ?? '';
//  }


  toJson() {
    return {
      "id": id,
      "name": name,
      "city": city,
      "imageUrl": imageUrl,
      "status": status,
      "dateCreated": dateCreated,
      "lat": lat,
      "lng": lng,
      "sex": sex,
      "description": description,
      "isVerify": isVerify,
      "isHide": isHide,
      "isOnline": isOnline,
      "lastVisitedAt": lastVisitedAt,
      "birthday": birthday,
      "email": email,
      "password": password,
      "phone": phone,
      "country": country,
      "countryCode": countryCode,
      "images": images
    };
  }

  //============================================================================
  String calculateAge() {
    if(birthday > 0) {
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
    } else {
      return '';
    }
  }

  bool isPhotoEmpty() {
    if(imageUrl.length == 0 || imageUrl == null) {
      return true;
    } else {
      buildPhotoList();
      return false;
    }

  }

  void buildPhotoList() {
    if(imageUrl != null) {
      images.insert(0, imageUrl);
    }
  }

  String getEmptyPhoto() {
    if(sex == 'Male') {
      return "assets/images/no_image_male.jpg";
    } else {
      return "assets/images/no_image_female.jpg";
    }
  }
}