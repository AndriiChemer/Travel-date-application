import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
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

  //TODO task add orderBy
  Stream<QuerySnapshot> getStreamChatListByUserId(String userId, int documentLimit) {
    print("ChatRepository");
    print("getStreamChatListByUserId");

    return _firestore
        .collection(Columns.CHAT_COLUMN)
        .where('users', arrayContainsAny: [{userId: true}])
        .orderBy('lastMessageAt', descending: true)
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
    }).catchError((onError) {
      print("ChatRepository updateChat");
      print('onError: ' + onError.toString());
    });
  }

  void updateFullChat(ChatModel chatModel) async {
    print("ChatRepository");
    print("updateFullChat");

    try {
      _firestore.collection(Columns.CHAT_COLUMN)
          .document(chatModel.groupChatId)
          .updateData(chatModel.updateJson())
          .then((onValue) {
        print('Chat has been updated successful');
      }).catchError((onError) {
        print("ChatRepository updateChat");
        print('onError: ' + onError.toString());
      });
    } catch (error) {
      print('Try catch error ');
    }
  }

  void updateUserInRoom(bool isUserInRoom, String yourId, String groupCharId) async {
    print("ChatRepository");
    print("updateUserInRoom");

    try {
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

      }).catchError((onError){
        print('updateUserInRoom onError = $onError');
      });

    } catch (onError) {
      print('updateUserInRoom catch onError = $onError');
    }




//    _firestore.collection(Columns.CHAT_COLUMN)
//        .document(groupCharId)
//        .collection("ids")
//        .where("userId", arrayContains: yourId).orderBy("ids", descending: false).getDocuments().then((onValue) {
//
//    });
  }

}