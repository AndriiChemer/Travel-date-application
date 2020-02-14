class MessageModel {
  String userId;

  String chatId;

  String groupChatId;
  //Date in milliseconds
  int createdAt;
  //Main message or image or sticker
  String content;
  //Type : 0 - message, 1 - image, 2 - sticker
  int type;

  MessageModel(this.userId, this.chatId, this.groupChatId, this.createdAt, this.content, this.type);

  MessageModel.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        chatId = snapshot['chatId'] ?? '',
        groupChatId = snapshot['groupChatId'] ?? '',
        createdAt = snapshot['createdAt'] as int ?? 0,
        content = snapshot['content'] ?? '',
        type = snapshot['type'] as int ?? -1;

  toJson() {
    return {
      "userId": userId,
      "chatId": chatId,
      "groupChatId": groupChatId,
      "createdAt": createdAt,
      "content": content,
      "type": type,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class MessageModelTest {
  List<String> ids;
  String status;

  MessageModelTest(this.ids, this.status);

  MessageModelTest.fromMap(Map snapshot) :
        ids = snapshot['ids'] == null ? [] : List.from(snapshot['ids']),
        status = snapshot['status'] ?? '';

  toJson() {
    return {
      "status": status,
      "ids": ids,
    };
  }

}