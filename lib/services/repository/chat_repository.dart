import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  // ignore: non_constant_identifier_names
  var CHAT_COLUMN = 'message';

  final Firestore _firestore =  Firestore.instance;

  Future<QuerySnapshot> getChatByUserId(String id) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await _firestore
        .collection(CHAT_COLUMN)
        .where('ids', arrayContains: id)
        .getDocuments();

    return querySnapshot;
  }

}