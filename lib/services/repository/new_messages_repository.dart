import 'package:cloud_firestore/cloud_firestore.dart';

import 'columns.dart';

class NewMessagesRepository {

  final Firestore _firestore =  Firestore.instance;

  Stream<DocumentSnapshot> getNewMessageCount(String userId) {
    return _firestore
        .collection(Columns.NEW_MESSAGES_COLUMN)
        .document(userId)
        .snapshots();
  }

  Future<bool> addNewUser(String userId) async {
    print("NewMessagesRepository");
    print("addNewUser");

    await _firestore.collection(Columns.NEW_MESSAGES_COLUMN)
        .document(userId)
        .setData({
      "counter" : 0
    });

    return true;
  }

  void incrementCounter(String userId) {
    updateCounter(userId, 1);
  }

  void decrementCounter(String userId) async {
    updateCounter(userId, -1);
  }

  void updateCounter(String userId, int value) async {
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