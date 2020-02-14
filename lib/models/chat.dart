import 'package:travel_date_app/models/person_model.dart';


// When we get chat then we check if our photo equals with photo in chat
class ChatModel {
  String chatId;
  //user id witch create chat
  String adminId;
  //Date in milliseconds
  int createdAt;
  //Date in milliseconds
  int lastMessageAt;
  // users id
  List<Ids> ids;
  //false if chat deleted
  bool isChatActive;
  // If message modify than messageModify++
  int messageModify;

  String groupChatId;

  String lastMessage;

  int lastContentType;


  ChatModel(this.chatId, this.adminId, this.ids, this.createdAt,
      this.lastMessageAt, this.isChatActive, this.messageModify, this.lastMessage, this.groupChatId, this.lastContentType);

  ChatModel.fromMap(Map snapshot) :
        chatId = snapshot['chatId'] ?? '',
        adminId = snapshot['adminId'] ?? '',
        groupChatId = snapshot['groupChatId'] ?? '',
        createdAt = snapshot['createdAt'] as int ?? 0,
        lastMessageAt = snapshot['lastMessageAt'] as int ?? 0,
        isChatActive = snapshot['isChatActive'] as bool ?? false,
        messageModify = snapshot['messageModify'] as int ?? 0,
        ids = snapshot['ids'] == null ? [] : parseListIds(snapshot),
        lastContentType = snapshot['lastContentType'] as int ?? -1,
        lastMessage = snapshot['lastMessage'] ?? '';

  toJson() {
    return {
      "chatId": chatId,
      "adminId": adminId,
      "lastMessageAt": lastMessageAt,
      "isChatActive": isChatActive,
      "messageModify": messageModify,
      "lastMessage": lastMessage,
      "createdAt": createdAt,
      "ids": ids,
      "groupChatId": groupChatId,
      "lastContentType": lastContentType,
    };
  }

  static List<Ids> parseListIds(Map snapshot) {
    return snapshot['ids'].map<Ids>((item) {
      return Ids.fromMap(item);
    }).toList();
  }

  //TODO Think about it
  UserModel adminModel;
  List<UserModel> users;
}

class Ids {
  String userId;
  int newMessageCount;
  bool isInRoom;

  Ids(this.userId, this.newMessageCount, this.isInRoom);

  Ids.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        isInRoom = snapshot['isInRoom'] as bool ?? 0,
        newMessageCount = snapshot['newMessageCount'] as int ?? 0;


  toJson() {
    return {
      "userId": userId,
      "isInRoom": isInRoom,
      "newMessageCount": newMessageCount,
    };
  }

}