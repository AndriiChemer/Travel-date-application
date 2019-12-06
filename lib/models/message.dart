class MessageModel {
  String userId;

  String chatId;
  //Date in milliseconds
  int createdAt;
  //Main message or image or sticker
  String content;
  //Type : 0 - message, 1 - image, 2 - sticker
  int type;

  MessageModel(this.userId, this.createdAt, this.content, this.type);

  MessageModel.map(dynamic obj) {
    userId = obj["userId"];
    createdAt = obj["createdAt"];
    content = obj["content"];
    type = obj["type"];
  }

  MessageModel.fromSnapShot() {

  }
}