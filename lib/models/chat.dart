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
  List<String> ids;
  //false if chat deleted
  bool isChatActive;
  // If message modify than messageModify++
  int messageModify;

  String groupChatId;

  String lastMessage;


  ChatModel(this.chatId, this.adminId, this.ids, this.createdAt,
      this.lastMessageAt, this.isChatActive, this.messageModify, this.lastMessage, this.groupChatId);

  ChatModel.fromMap(Map snapshot) :
        chatId = snapshot['chatId'] ?? '',
        adminId = snapshot['adminId'] ?? '',
        groupChatId = snapshot['groupChatId'] ?? '',
        createdAt = snapshot['createdAt'] as int ?? 0,
        lastMessageAt = snapshot['lastMessageAt'] as int ?? 0,
        isChatActive = snapshot['isChatActive'] as bool ?? false,
        messageModify = snapshot['messageModify'] as int ?? 0,
        ids = snapshot['ids'] == null ? [] : List.from(snapshot['ids']),
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
    };
  }
  // Think about it
  UserModel adminModel;
  List<UserModel> users;
}