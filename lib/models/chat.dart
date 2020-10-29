import 'package:travel_date_app/models/user_model.dart';


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

  Map<String, dynamic> users;

  ChatModel(this.chatId, this.adminId, this.ids, this.createdAt,
      this.lastMessageAt, this.isChatActive, this.messageModify, this.lastMessage, this.groupChatId, this.lastContentType, this.users);

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
      "ids": convertListToMap(ids),
      "groupChatId": groupChatId,
      "lastContentType": lastContentType,
      "users": users,
    };
  }

  updateJson() {
    return {
      "chatId": chatId,
      "adminId": adminId,
      "lastMessageAt": lastMessageAt,
      "isChatActive": isChatActive,
      "messageModify": messageModify,
      "lastMessage": lastMessage,
      "createdAt": createdAt,
      "ids": convertListToMap(ids),
      "groupChatId": groupChatId,
      "lastContentType": lastContentType,
    };
  }


  @override
  String toString() {
    return toJson().toString();
  }

  static List<Map> convertListToMap(List<Ids> ids) {
    List<Map> steps = [];
    ids.forEach((Ids id) {
      Map step = id.toJson();
      steps.add(step);
    });
    return steps;
  }

  static List<Ids> parseListIds(Map snapshot) {
    return snapshot['ids'].map<Ids>((item) {
      return Ids.fromMap(item);
    }).toList();
  }

  static List<String> parseUserIDList(Map snapshot) {
    return snapshot['users'].map<String>((item) {
      return item as String;
    }).toList();
  }

  //TODO Think about it
  UserModel adminModel;
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