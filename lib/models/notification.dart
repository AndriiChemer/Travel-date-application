class KissWatchNotifModel {
  String userId;
  String notificationId;
  int createdAt;
  bool isWatched;

  KissWatchNotifModel(this.userId, this.notificationId, this.createdAt, this.isWatched);

  KissWatchNotifModel.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        notificationId = snapshot['notificationId'] ?? '',
        createdAt = snapshot['createdAt'] as int ?? 0,
        isWatched = snapshot['isWatched'] as bool ?? false;

  toJson() {
    return {
      "userId": userId,
      "notificationId": notificationId,
      "createdAt": createdAt,
      "isWatched": isWatched,
    };
  }
}