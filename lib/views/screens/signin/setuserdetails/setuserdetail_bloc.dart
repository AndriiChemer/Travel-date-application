import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/LocationService.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/new_messages_repository.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class SetUserDetailBloc extends BlocBase {
  SetUserDetailBloc();

  UserPreferences userPreferences = UserPreferences();
  UserRepository userRepository = UserRepository();
  NewMessagesRepository newMessageRepository = NewMessagesRepository();

  Placemark userPlace;
  LocationData location;

  var stateController = BehaviorSubject<int>();
  var ageController = BehaviorSubject<DateTime>();
  var userController = BehaviorSubject<UserModel>();

  var messageErrorController = BehaviorSubject<String>();
  var loadingProgressController = BehaviorSubject<bool>.seeded(false);

  Stream<int> get stateStream => stateController.stream;
  Sink<int> get stateSink => stateController.sink;

  Stream<DateTime> get ageStream => ageController.stream;
  Sink<DateTime> get ageSink => ageController.sink;

  Stream<UserModel> get userStream => userController.stream;
  Sink<UserModel> get userSink => userController.sink;

  Stream<String> get errorStream => messageErrorController.stream;
  Sink<String> get messageErrorSink => messageErrorController.sink;

  Stream<bool> get progressStream => loadingProgressController.stream;
  Sink<bool> get progressSink => loadingProgressController.sink;

  /// state = 0 - male
  /// state = 1 - female
  void setUserState(int state) {
    String stateName = state == 0 ? 'Male' : state == 1 ? 'Female' : 'Not selected!';
    print("User state is: $stateName}");
    stateSink.add(state);
  }

  void setAgeSelected(DateTime selectedDate) {
    print("User age is: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year})}");
    ageSink.add(selectedDate);
  }

  void _openNextScreen(UserModel user) {
    progressSink.add(true);

    userRepository.addNewUser(user)
        .then((value) {
          userPreferences.writeUser(user);
          newMessageRepository.addNewUser(user.id);
          progressSink.add(false);
          userSink.add(user);
        }).then((error) {
            progressSink.add(false);
            messageErrorSink.add(error.toString());
        });
  }

  Future<DateTime> selectDate(BuildContext context) async {
    DateTime nowDate = DateTime.now();

    final DateTime birthDate = await showDatePicker(
        context: context,
        initialDate: DateTime(nowDate.year - 16),
        firstDate: DateTime(1920, 8),
        lastDate: nowDate);

    return birthDate;
  }

  void onButtonClick(FirebaseUser firebaseUser, int millisecondsDateBirthday, int state) {
    String id = firebaseUser.uid;
    String name = firebaseUser.displayName;
    String email = firebaseUser.email;
    int dateCreated = DateTime.now().millisecondsSinceEpoch * 1000;

    UserModel newUser = UserModel(id: id, name: name, email: email, isOnline: true, dateCreated: dateCreated);
    newUser.birthday = millisecondsDateBirthday * 1000;
    newUser.sex = state == 0 ? "Male" : "Female";

    if(firebaseUser.photoUrl != null) {
      newUser.imageUrl = firebaseUser.photoUrl;
    }

    if(firebaseUser.phoneNumber != null) {
      newUser.phone = firebaseUser.phoneNumber;
    }

    if(userPlace != null) {
      newUser.countryCode = userPlace.isoCountryCode;
      newUser.city = userPlace.locality;
      newUser.country = userPlace.country;
      newUser.countryCode = userPlace.isoCountryCode;
      newUser.lat = location.latitude;
      newUser.lng = location.longitude;
      printUserLocation(userPlace);

    } else {
      print("User place is null");
    }

    _openNextScreen(newUser);
  }

  printUserLocation(Placemark place) {
    print("Place info:\n"
        "Name: ${place.name}\n "
        "AdministrativeArea: ${place.administrativeArea}\n "
        "Country: ${place.country}\n "
        "IsoCountryCode: ${place.isoCountryCode}\n "
        "Locality: ${place.locality}\n "
        "SubLocality: ${place.subLocality}\n "
        "PostalCode: ${place.postalCode}");
  }

  void getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

    LocationService()
        .getLocation()
        .then((location) async {
          List<Placemark> places = await geolocator.placemarkFromCoordinates(
              location.latitude, location.longitude);
          this.location = location;
          Placemark place = places[0];
          this.userPlace = place;
        });
  }

  @override
  void dispose() {
    stateController.close();
    ageController.close();
    userController.close();
    loadingProgressController.close();
    messageErrorController.close();
    super.dispose();
  }

  String calculateAge(DateTime birthDate) {
    print(birthDate);
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
}