import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/person_model.dart';

class ChatModel {
  String chatId;
  //user id witch create chat
  String adminId;
  // Users who are in chat
  List<String> usersId;
  //Date in milliseconds
  int createdAt;
  //Date in milliseconds
  int lastMessageAt;

  List<MessageModel> messages;
  //false if chat deleted
  bool isChatActive;
  // If message modify than messageModify++
  int messageModify;


  // Think about it
  UserModel adminModel;
  List<UserModel> users;
}