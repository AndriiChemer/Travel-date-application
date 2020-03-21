class KissWatchNotifModel {
  String fromUserId;
  String toUserId;
  String notificationId;
  int createdAt;
  bool isWatched;

  KissWatchNotifModel(this.fromUserId, this.toUserId, this.notificationId, this.createdAt, this.isWatched);

  KissWatchNotifModel.fromMap(Map snapshot) :
        fromUserId = snapshot['fromUserId'] ?? '',
        toUserId = snapshot['toUserId'] ?? '',
        notificationId = snapshot['notificationId'] ?? '',
        createdAt = snapshot['createdAt'] as int ?? 0,
        isWatched = snapshot['isWatched'] as bool ?? false;

  toJson() {
    return {
      "fromUserId": fromUserId,
      "toUserId": toUserId,
      "notificationId": notificationId,
      "createdAt": createdAt,
      "isWatched": isWatched,
    };
  }
}