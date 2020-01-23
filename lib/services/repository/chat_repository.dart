import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/chat.dart';

class ChatRepository {
  // ignore: non_constant_identifier_names
  var CHAT_COLUMN = 'chat_dt';

  final Firestore _firestore =  Firestore.instance;

  Future<QuerySnapshot> getChatByUserId(String id) async {
    QuerySnapshot querySnapshot;

    querySnapshot = await _firestore
        .collection('message')
        .where('ids', arrayContainsAny: [id, 'gsfdgdfsgdfsg'])
        .getDocuments();

    return querySnapshot;
  }

  Stream<QuerySnapshot> getStreamChatListByUserId(String userId, int documentLimit) {
    print("ChatRepository");
    print("getStreamChatListByUserId");
    return _firestore
        .collection(CHAT_COLUMN)
//        .where('ids', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .limit(documentLimit)
        .snapshots();
  }

  Future<bool> createChat(ChatModel chatModel) async {
    print("ChatRepository");
    print("createChat");

    final QuerySnapshot result = await _firestore.collection(CHAT_COLUMN).where('groupChatId', isEqualTo: chatModel.groupChatId).getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      _firestore.collection(CHAT_COLUMN)
          .document(chatModel.groupChatId)
          .setData(chatModel.toJson());
    } else {
      return false;
    }

    return true;
  }

  Future<void> updateChat(String groupChatId, String lastMessage, int lastMessageAt, int lastContentType) async {
    print("ChatRepository");
    print("updateChat");

    _firestore.collection(CHAT_COLUMN)
        .document(groupChatId)
        .updateData({
      "lastMessage" : lastMessage,
      "lastMessageAt" : lastMessageAt,
      "lastContentType" : lastContentType,
    })
        .then((onValue) {
      print('Chat has been updated successful');
    }).catchError((onError) {
      print("ChatRepository updateChat");
      print('onError: ' + onError.toString());
    });
  }

}