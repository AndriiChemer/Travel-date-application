import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/message.dart';

import 'columns.dart';

class MessageRepository {

  final Firestore _firestore =  Firestore.instance;

  Future<QuerySnapshot> getChatByUserId(String id) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await _firestore
        .collection(Columns.MESSAGE_COLUMN)
        .where('ids', arrayContains: id)
        .where('ids', arrayContains: 'gsfdgdfsgdfsg')
        .getDocuments();

    return querySnapshot;
  }

  Stream<QuerySnapshot> getStreamMessagesByGroupChatId(String groupChatId, int documentLimit) {
    return _firestore
        .collection(Columns.MESSAGE_COLUMN)
        .where('groupChatId', isEqualTo: groupChatId)
        .orderBy('createdAt', descending: true)
        .limit(documentLimit)
        .snapshots();
  }

  //TODO use it
  Stream<QuerySnapshot> getStreamMessagesByGroupChatId1(String groupChatId, int documentLimit) {
    return _firestore
        .collection("Message_test_column")
        .document(groupChatId)
        .collection(groupChatId)
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
          .collection(Columns.MESSAGE_COLUMN)
          .where('groupChatId', isEqualTo: groupChatId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(Columns.MESSAGE_COLUMN)
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
    sendMessageNewColumn(messageModel);
    return _firestore.collection(Columns.MESSAGE_COLUMN).add(messageModel.toJson());
  }

  //TODO use it
  void sendMessageNewColumn(MessageModel messageModel) async {
    _firestore.collection("Message_test_column")
        .document(messageModel.groupChatId)
        .collection(messageModel.groupChatId)
        .add(messageModel.toJson())
        .then((onValue) {
      setMessageIdNewColumn(onValue.documentID, messageModel.groupChatId);
    });
  }

  //TODO use it
  void setMessageIdNewColumn(String messageId, String groupChatId) {
    _firestore.collection("Message_test_column")
        .document(groupChatId)
        .collection(groupChatId)
        .document(messageId)
        .updateData({"messageId" : messageId});
  }



  void setMessageId(String messageId) {
    print("messageId = $messageId");
    _firestore.collection(Columns.MESSAGE_COLUMN).document(messageId).updateData({"messageId" : messageId});
  }

  Stream<QuerySnapshot> getStreamNewMessageCount(String userId) {
    print("getStreamNewMessageCount User id $userId");
    return _firestore.collection(Columns.MESSAGE_COLUMN)
        .where("isWatched", isEqualTo: false)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getNewMessageBottomNavCounter(String userId) {
    print("getNewMessageBottomNavCounter User id $userId");
    return _firestore.collection(Columns.MESSAGE_COLUMN)
        .where("isWatched", isEqualTo: false)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  void updateMessage(MessageModel message) {
    print("\n\n\n==================================================");
    print("message has been updated:\n${message.toString()}");
//    _firestore.collection(Columns.MESSAGE_COLUMN)
//        .document(message.messageId)
//        .updateData(message.toJson());

//    _firestore.collection(Columns.MESSAGE_COLUMN)
//        .document(message.groupChatId)
//        .collection(message.groupChatId)
//        .document(message.messageId)
//        .updateData(message.toJson());
  }
}