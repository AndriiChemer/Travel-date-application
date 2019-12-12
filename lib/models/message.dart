class MessageModel {
  String userId;

  String chatId;
  //Date in milliseconds
  int createdAt;
  //Main message or image or sticker
  String content;
  //Type : 0 - message, 1 - image, 2 - sticker
  int type;

  MessageModel(this.userId, this.chatId, this.createdAt, this.content, this.type);

  MessageModel.map(dynamic obj) {
    userId = obj["userId"];
    chatId = obj["chatId"];
    createdAt = obj["createdAt"];
    content = obj["content"];
    type = obj["type"];
  }

  MessageModel.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        chatId = snapshot['chatId'] ?? '',
        createdAt = snapshot['createdAt'] ?? 0,
        content = snapshot['content'] ?? '',
        type = snapshot['type'] ?? -1;

  toJson() {
    return {
      "userId": userId,
      "chatId": chatId,
      "createdAt": createdAt,
      "content": content,
      "type": type,
    };
  }
}