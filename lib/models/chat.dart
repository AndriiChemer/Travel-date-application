import 'package:travel_date_app/models/chat_user_info.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/person_model.dart';


// When we get chat then we check if our photo equals with photo in chat
class ChatModel {
  String chatId;
  //user id witch create chat
  String adminId;
  // Users who are in chat
  List<ChatUserInfo> usersInfo = [];
  //Date in milliseconds
  int createdAt;
  //Date in milliseconds
  int lastMessageAt;

  List<MessageModel> messages;
  //false if chat deleted
  bool isChatActive;
  // If message modify than messageModify++
  int messageModify;

  String lastMessage;


  ChatModel(this.chatId, this.adminId, this.usersInfo, this.createdAt,
      this.lastMessageAt, this.messages, this.isChatActive, this.messageModify, this.lastMessage);

  ChatModel.map(dynamic obj) {
    this.chatId = obj["chatId"];
    this.adminId = obj["adminId"];
    this.usersInfo = obj["usersInfo"];
    this.createdAt = obj["createdAt"];
    this.lastMessageAt = obj["lastMessageAt"];
    this.isChatActive = obj["isChatActive"];
    this.messageModify = obj["messageModify"];
  }

  ChatModel.fromMap(Map snapshot, String chatId) {
    chatId = chatId ?? '';
    adminId = snapshot['adminId'] ?? '';

    List<ChatUserInfo> temp = [];
    for(int i = 0; i < snapshot['usersInfo'].length; i++) {
      ChatUserInfo result = ChatUserInfo.fromMap(snapshot['usersInfo'][0]);
      temp.add(result);
    }
    usersInfo = snapshot['usersInfo'] ?? null;
    lastMessageAt = snapshot['lastMessageAt'] ?? 0.0;
    isChatActive = snapshot['isChatActive'] ?? false;
    messageModify = snapshot['messageModify'] ?? 0;
    lastMessage = snapshot['lastMessage'] ?? '';
    createdAt = snapshot['createdAt'] ?? 0.0;

    usersInfo = temp;
  }

  toJson() {
    return {
      "chatId": chatId,
      "adminId": adminId,
      "usersInfo": usersInfo,
      "lastMessageAt": lastMessageAt,
      "isChatActive": isChatActive,
      "messageModify": messageModify,
      "lastMessage": lastMessage,
      "createdAt": createdAt,
    };
  }
  // Think about it
  UserModel adminModel;
  List<UserModel> users;
}