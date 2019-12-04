class MessageModel {
  String userId;
  //Date in milliseconds
  int createdAt;
  //Main message or image or sticker
  String content;
  //Type : 0 - message, 1 - image, 2 - sticker
  int type;
}