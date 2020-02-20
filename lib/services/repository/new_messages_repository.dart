import 'package:cloud_firestore/cloud_firestore.dart';

import 'columns.dart';

class NewMessagesRepository {

  final Firestore _firestore =  Firestore.instance;

  Stream<QuerySnapshot> getNewMessageCount(String userId) {
    return _firestore
        .collection(Columns.NEW_MESSAGES_COLUMN)
        .snapshots();
  }

  Future<bool> addNewUser(String userId) async {
    print("NewMessagesRepository");
    print("addNewUser");

    final QuerySnapshot result = await _firestore.collection(Columns.NEW_MESSAGES_COLUMN)
        .where('id', isEqualTo: userId)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {

      _firestore.collection(Columns.NEW_MESSAGES_COLUMN)
          .document(userId)
          .setData({
        "counter" : 0
      });
    } else {
      return false;
    }

    return true;
  }

  void incrementCounter(String userId) {
    updateCounter(userId, 1);
  }

  void decrementCounter(String userId) {
    updateCounter(userId, -1);
  }

  Future<void> updateCounter(String userId, int value) async {
    print("UserRepository");
    print("updateUser");

    _firestore.collection(Columns.NEW_MESSAGES_COLUMN)
        .document(userId)
        .updateData({
      "counter" : FieldValue.increment(value)
    })
        .then((onValue) {
      print('Counter has been updated successful');
    }).catchError((onError) {
      print("NewMessagesRepository incrementCounter");
      print('onError: ' + onError.toString());
    });
  }
}