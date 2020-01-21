import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/message.dart';

class MessageRepository {
  // ignore: non_constant_identifier_names
  var MESSAGE_COLUMN = 'message_dt';

  final Firestore _firestore =  Firestore.instance;

  Future<QuerySnapshot> getChatByUserId(String id) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await _firestore
        .collection(MESSAGE_COLUMN)
        .where('ids', arrayContains: id)
        .where('ids', arrayContains: 'gsfdgdfsgdfsg')
        .getDocuments();

    return querySnapshot;
  }

  Stream<QuerySnapshot> getStreamMessagesByGroupChatId(String groupChatId, int documentLimit) {
    return _firestore
        .collection(MESSAGE_COLUMN)
        .where('groupChatId', isEqualTo: groupChatId)
        .orderBy('createdAt', descending: true)
        .limit(documentLimit)
        .snapshots();
  }

  Future<QuerySnapshot> getMessagesByGroupChatId(
      String groupChatId,
      DocumentSnapshot lastDocument,
      int documentLimit) async {

    print("MessageRepository");
    print("getMessagesByGroupChatId groupChatId = $groupChatId");

    QuerySnapshot querySnapshot;

    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(MESSAGE_COLUMN)
          .where('groupChatId', isEqualTo: groupChatId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(MESSAGE_COLUMN)
          .where('groupChatId', isEqualTo: groupChatId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }

  Future<DocumentReference> sendMessage(MessageModel messageModel) async {
    return _firestore.collection(MESSAGE_COLUMN).add(messageModel.toJson());
  }
}