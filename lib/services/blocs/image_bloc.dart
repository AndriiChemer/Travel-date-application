import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class ImageBloc {
  final _userRepository = UserRepository();
  var _showProgress = BehaviorSubject<bool>();
  var _image = BehaviorSubject<String>();

  Observable<bool> get showProgress => _showProgress.stream;
  Observable<String> get image => _image.stream;

  uploadImage(File image, String userId) {
    _showProgress.sink.add(true);
    _userRepository.uploadImageProfile(image, userId).then((imageUrl) {
      _image.sink.add(imageUrl);
      _showProgress.sink.add(false);
    }).catchError((onError){
      //TODO task show error for user
      
      _showProgress.sink.add(false);
    });
  }

  addListImage(List<String> list) {
    for(String image in list) {
      _image.sink.add(image);
    }
    _image.sink.add('');
  }

  addImage(String image) {
    _image.value = image;
    _image.sink.add('');
  }



  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();

    await _image.drain();
    _image.close();
  }
}