import 'dart:io';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:path/path.dart' as path;

class UserRepository {

  // ignore: non_constant_identifier_names
  var USER_COLUMN = 'users_dt';

  final Firestore _firestore =  Firestore.instance;

  // get users list info


  Future<bool> addNewUser(UserModel userModel) async {
    print("UserRepository");
    print("addNewUser");

    final QuerySnapshot result = await _firestore.collection(USER_COLUMN).where('id', isEqualTo: userModel.id).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {

      _firestore.collection(USER_COLUMN)
          .document(userModel.id)
          .setData(userModel.toJson());
    } else {
      return false;
    }

    return true;
  }

  Future<void> updateUser(UserModel userModel) async {
    print("UserRepository");
    print("updateUser");

    _firestore.collection(USER_COLUMN)
        .document(userModel.id)
        .updateData(userModel.toJson())
        .then((onValue) {
          print('User has been updated successful');
        }).catchError((onError) {
          print("UserRepository updateUser");
          print('onError: ' + onError.toString());
        });
  }
  
  Future<void> handleOnlineState(String userID, bool isOnline) async {
    print('User id: $userID');
    int date = DateTime.now().millisecondsSinceEpoch * 1000;

    _firestore.collection(USER_COLUMN)
        .document(userID)
        .updateData({
          'isOnline': isOnline,
          'lastVisitedAt': date
        }).then((onValue) {
          print("Update user online state.");
        });
  }

  Future<UserModel> getUsersById(String id) async {
    print("UserRepository");
    print("getUsersById");

    DocumentSnapshot querySnapshot = await _firestore
        .collection(USER_COLUMN)
        .document(id).get();

    print('querySnapshot.data');
    print(querySnapshot.data.toString());

    return UserModel.fromMap(querySnapshot.data);
  }

  Stream<QuerySnapshot> getUserByIdStream(String id) {
    return _firestore
        .collection(USER_COLUMN)
        .where('id', isEqualTo: id)
        .snapshots();
  }

  //TODO task uncomment where
  Future<QuerySnapshot> getUsersByLocation(String city, DocumentSnapshot lastDocument, int documentLimit) async {
    print("UserRepository");
    print("getUsersByLocation");

    QuerySnapshot querySnapshot;
    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
//          .where('city', isEqualTo: city)
          .orderBy('lastVisitedAt')
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
//          .where('city', isEqualTo: city)
          .orderBy('lastVisitedAt')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }

  Future<QuerySnapshot> getUsers(DocumentSnapshot lastDocument, int documentLimit) async {
    print("UserRepository");
    print("getUsers");

    QuerySnapshot querySnapshot;
    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
          .orderBy('lastVisitedAt')
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
          .orderBy('lastVisitedAt')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }

  Future<String> uploadImageProfile(File image, String userId) async {
    var fileName = path.basename(image.path);
    Uint8List fileBytes = image.readAsBytesSync();

    StorageReference storageReference = FirebaseStorage.instance.ref().child('profiles/').child(userId).child(fileName);
    StorageUploadTask uploadTask = storageReference.putData(fileBytes);

    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    await uploadTask.onComplete;
    streamSubscription.cancel();

    var imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  Future<void> uploadUserImage(String imageUrl, String id) {
    print("UserRepository");
    print("uploadUserImage");

    _firestore.collection(USER_COLUMN)
        .document(id)
        .updateData({'imageUrl' : imageUrl})
        .then((onValue) {
      print('User\'s avatar  been updated successful');
    }).catchError((onError) {
      print("UserRepository uploadUserImage");
      print('onError: ' + onError.toString());
    });
  }

  Future<void> addGalleryImage(UserModel user) {
    print("UserRepository");
    print("uploadUserImage");

    _firestore.collection(USER_COLUMN)
        .document(user.id)
        .updateData({'images' : FieldValue.arrayUnion(user.images)})
        .then((onValue) {
      print('User\'s gallery has been updated successful');
    }).catchError((onError) {
      print("UserRepository uploadUserImage");
      print('onError: ' + onError.toString());
    });
  }

//  Future<QuerySnapshot> getUserById(String userId) async {
//    print("UserRepository");
//    print("getUserById userId = $userId");
//
//    return await _firestore.collection(USER_COLUMN)
//        .where('id', isEqualTo: userId)
//        .getDocuments();
//  }

//  Stream<QuerySnapshot> getUsersByLocation(String city, DocumentSnapshot lastDocument, int documentLimit) {
//    print("UserRepository");
//    print("getUsersByLocation");
//
//    Stream<QuerySnapshot> querySnapshot;
//    if(lastDocument == null) {
//
//      querySnapshot = _firestore
//          .collection(USER_COLUMN)
//          .where('city', isEqualTo: city)
//          .orderBy('dateCreated')
//          .limit(documentLimit)
//          .snapshots();
//
//    } else {
//
//      querySnapshot = _firestore
//          .collection(USER_COLUMN)
//          .where('city', isEqualTo: city)
//          .orderBy('dateCreated')
//          .startAfterDocument(lastDocument)
//          .limit(documentLimit)
//          .snapshots();
//
//    }
//    return querySnapshot;
//  }
}