class KissWatchNotifModel {
  String userId;
  String notificationId;
  int cratedAt;
  bool isWatched;

  KissWatchNotifModel.fromMap(Map snapshot) :
        userId = snapshot['userId'] ?? '',
        notificationId = snapshot['notificationId'] ?? '',
        cratedAt = snapshot['cratedAt'] as int ?? 0,
        isWatched = snapshot['isWatched'] as bool ?? false;

  toJson() {
    return {
      "userId": userId,
      "notificationId": notificationId,
      "cratedAt": cratedAt,
      "isWatched": isWatched,
    };
  }
}