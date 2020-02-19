import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/chat.dart';

import 'columns.dart';

class ChatRepository {

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
        .collection(Columns.CHAT_COLUMN)
        .orderBy('createdAt', descending: true)
        .limit(documentLimit)
        .snapshots();
  }

  Future<bool> createChat(ChatModel chatModel) async {
    print("ChatRepository");
    print("createChat");

    final QuerySnapshot result = await _firestore.collection(Columns.CHAT_COLUMN)
        .where('groupChatId', isEqualTo: chatModel.groupChatId)
        .getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 0) {
      _firestore.collection(Columns.CHAT_COLUMN)
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

    _firestore.collection(Columns.CHAT_COLUMN)
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

  Future<void> updateFullChat(ChatModel chatModel) async {
    print("ChatRepository");
    print("updateFullChat");

    _firestore.collection(Columns.CHAT_COLUMN)
        .document(chatModel.groupChatId)
        .updateData(chatModel.toJson())
        .then((onValue) {
      print('Chat has been updated successful');
    }).catchError((onError) {
      print("ChatRepository updateChat");
      print('onError: ' + onError.toString());
    });
  }

//  void incrementNewMessageInChat(String grpChtId, String userId) {
//    print("ChatRepository");
//    print("updatincrementNewMessageInChateUserInRoom");
//    _firestore.collection(Columns.CHAT_COLUMN)
//        .document(grpChtId)
//        .collection("ids")
//        .document(userId)
//        .where('userId', isEqualTo: userId)
//        .updateData({"newMessageCoun" : FieldValue.increment(1)});
//  }

  void updateUserInRoom(bool isUserInRoom, String yourId, String groupCharId) {
    print("ChatRepository");
    print("updateUserInRoom");
    _firestore.collection(Columns.CHAT_COLUMN)
        .document(groupCharId).get()
        .then((result) {

      ChatModel model = ChatModel.fromMap(result.data);

      for(Ids user in model.ids) {
        if(user.userId == yourId) {
          user.isInRoom = isUserInRoom;
          break;
        }
      }

      updateFullChat(model);

    });



//    _firestore.collection(Columns.CHAT_COLUMN)
//        .document(groupCharId)
//        .collection("ids")
//        .where("userId", arrayContains: yourId).orderBy("ids", descending: false).getDocuments().then((onValue) {
//
//    });
  }

}