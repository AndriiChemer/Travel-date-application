
class NewMessage {

  String userId;
  int newMessageCount;

  NewMessage(this.userId, this.newMessageCount);

  NewMessage.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        newMessageCount = snapshot['newMessageCount'] as int ?? 0;

  toJson() {
    return {
      "userId": userId,
      "newMessageCount": newMessageCount,
    };
  }
}