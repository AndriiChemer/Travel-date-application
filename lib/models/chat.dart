import 'package:travel_date_app/models/chat_user_info.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/person_model.dart';

class ChatModel {
  String chatId;
  //user id witch create chat
  String adminId;
  // Users who are in chat
  List<ChatUserInfo> usersInfo;
  //Date in milliseconds
  int createdAt;
  //Date in milliseconds
  int lastMessageAt;

  List<MessageModel> messages;
  //false if chat deleted
  bool isChatActive;
  // If message modify than messageModify++
  int messageModify;


  ChatModel(this.chatId, this.adminId, this.usersInfo, this.createdAt,
      this.lastMessageAt, this.messages, this.isChatActive, this.messageModify);

  ChatModel.map(dynamic obj) {
    this.chatId = obj["chatId"];
    this.adminId = obj["adminId"];
    this.usersInfo = obj["usersInfo"];
    this.createdAt = obj["createdAt"];
    this.lastMessageAt = obj["lastMessageAt"];
    this.messages = obj["messages"];
    this.isChatActive = obj["isChatActive"];
    this.messageModify = obj["messageModify"];
  }

  // Think about it
  UserModel adminModel;
  List<UserModel> users;
}