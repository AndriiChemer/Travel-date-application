import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class ImageBloc {
  List<String> imagesUrl = [];

  final _userRepository = UserRepository();
  final _userPreferences = UserPreferences();

  /// Images message
  var _imageListController = BehaviorSubject<List<String>>();
  Stream<List<String>> get imagesStream => _imageListController.stream;
  Sink<List<String>> get _imagesSink => _imageListController.sink;

  uploadImage(File image, UserModel user) async {
    //TODO show image list with last image loading
    List<String> loadImages = _imageListController.value;
    loadImages.add('loading');
    _imagesSink.add(loadImages);

    _userRepository.uploadImageProfile(image, user.id).then((imageUrl) async {
      if(user.imageUrl == "") {
        user.imageUrl = imageUrl;
        _userPreferences.setUserImage(imageUrl);
        _userRepository.setUserImage(imageUrl, user.id);
      }

      List<String> images = await _userPreferences.addGalleryImage(imageUrl);
      _userRepository.updateGallery(user.id, images);

      _imagesSink.add(images);
    }).catchError((onError){
      //TODO task show error for user

    });
  }

  removeImage(String userId, String imageUrl) async {
    _userRepository.removeImage(userId, imageUrl);
    _userPreferences.removeImageFromGallery(imageUrl).then((imageList) {

      _userRepository.updateGallery(userId, imageList);

      _imagesSink.add(imageList);
    });
  }

  setAsProfileImage(String userId, String imageUrl) async {
    _userPreferences.setUserImage(imageUrl);
    _userRepository.setUserImage(imageUrl, userId);
    List<String> images = await _userPreferences.setImageAsProfile(imageUrl);

    _userRepository.updateGallery(userId, images);
    _imagesSink.add(images);
  }

  prepareUserImages() {
    _userPreferences.getGalleryImages().then((images) {
      _imagesSink.add(images);
    });
  }

  void dispose() async {
    await _imageListController.drain();
    _imageListController.close();
  }
}