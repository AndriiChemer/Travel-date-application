import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/person_model.dart';

class UserRepository {

  var USER_COLUMN = 'users_dt';

  final Firestore _firestore =  Firestore.instance;

  Future<bool> addNewUser(UserModel userModel) async {
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
}