import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/person_model.dart';

class UserRepository {

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

  Future<QuerySnapshot> getUsersByLocation(String city, DocumentSnapshot lastDocument, int documentLimit) async {
    print("UserRepository");
    print("getUsersByLocation");

    QuerySnapshot querySnapshot;
    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
          .where('city', isEqualTo: city)
          .orderBy('dateCreated')
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(USER_COLUMN)
          .where('city', isEqualTo: city)
          .orderBy('dateCreated')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }
}