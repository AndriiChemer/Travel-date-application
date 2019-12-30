import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class ImageBloc {
  List<String> imagesUrl = [];

  final _userRepository = UserRepository();
  final _userPreferences = UserPreferences();
  var _showProgress = BehaviorSubject<bool>();
  var _image = BehaviorSubject<String>();

  Observable<bool> get showProgress => _showProgress.stream;
  Stream<String> get image => _image.stream;

  uploadImage(File image, UserModel user) async {
    _userRepository.uploadImageProfile(image, user.id).then((imageUrl) async {
      if(user.imageUrl == "") {
        user.imageUrl = imageUrl;
        _userPreferences.setUserImage(imageUrl);
        _userRepository.uploadUserImage(imageUrl, user.id);
      } else {
        user.images.add(imageUrl);
        _userRepository.addGalleryImage(user);
        _userPreferences.addGalleryImage(imageUrl);
      }
    }).catchError((onError){
      //TODO task show error for user

    });
  }

  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();

    await _image.drain();
    _image.close();
  }
}