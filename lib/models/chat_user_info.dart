import 'package:travel_date_app/models/person_model.dart';

/**
 * If user isChatOpen = false => newMessageCount++, if isChatOpen = true => newMessageCount = 0;
 *
 * */
class ChatUserInfo {
  String userId;
  String imageUrl;
  int newMessageCount;
  bool isChatOpen;
  String chatName;

  ChatUserInfo(this.userId, this.imageUrl, this.newMessageCount, this.isChatOpen, this.chatName);

  ChatUserInfo.map(dynamic obj) {
    this.userId = obj["userId"];
    this.imageUrl = obj["imageUrl"];
    this.newMessageCount = obj["newMessageCount"];
    this.isChatOpen = obj["isChatOpen"];
  }

  ChatUserInfo.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        newMessageCount = snapshot['newMessageCount'] ?? 0,
        isChatOpen = snapshot['isChatOpen'] ?? false,
        chatName = snapshot['chatName'] ?? '';

  toJson() {
    return {
      "imageUrl": imageUrl,
      "newMessageCount": newMessageCount,
      "isChatOpen": isChatOpen,
      "chatName": chatName,
    };
  }

  UserModel user;
}