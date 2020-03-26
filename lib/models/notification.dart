class KissWatchNotifModel {
  String fromUserId; //yGTQM94ACKPDyIeEsKprDCQms5g1
  String toUserId; //FDIw3gV89JeAmaAxkkmkwTzWf5x2
  String notificationId;
  int createdAt; //1585229671959000
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