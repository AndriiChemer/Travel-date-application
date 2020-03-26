import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/notification.dart';

import 'columns.dart';

class NotificationRepository {
  final Firestore _firestore =  Firestore.instance;

  Stream<QuerySnapshot> getKissNotificationCount(String userId) {
    return _firestore.collection(Columns.KISSED_COLUMN)
        .where('toUserId', isEqualTo: userId)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getWatchedAccountNotificationCount(String userId) {
    return _firestore.collection(Columns.WATCHED_COLUMN)
        .where('toUserId', isEqualTo: userId)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //===============================Watched======================================
  Future<QuerySnapshot> getKissedWatchedNotification(
      String userId,
      String column,
      DocumentSnapshot lastDocument,
      int documentLimit) async {

    QuerySnapshot querySnapshot;

    if(lastDocument == null) {
      querySnapshot = await _firestore
          .collection(column)
          .where('toUserId', isEqualTo: userId)
          .where('isWatched', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await _firestore
          .collection(column)
          .where('toUserId', isEqualTo: userId)
          .where('isWatched', isEqualTo: false)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();
    }

    return querySnapshot;
  }

  Future<QuerySnapshot> getNotificationByIds(String column, String fromUserId, toUserId) {
    return _firestore.collection(column)
        .where('fromUserId', isEqualTo: fromUserId)
        .where('toUserId', isEqualTo: toUserId)
        .getDocuments();
  }

  Future<DocumentReference> sendWatchKissedNotification(String column, String fromUserId, toUserId, int notificationCreatedAt, bool isWatched) {
    var model = KissWatchNotifModel(fromUserId, toUserId, '', notificationCreatedAt, isWatched);

    return _firestore.collection(column)
        .add(model.toJson());
  }

  void resendNotification(String column, String notificationId, int notificationCreatedAt) async {
    _firestore.collection(column)
        .document(notificationId)
        .updateData({
          "isWatched" : false,
          "createdAt": notificationCreatedAt
        });
  }

  void setNotificationId(String column, String userId, String documentID) {
    _firestore.collection(column)
        .document(documentID)
        .updateData({ "notificationId" : documentID });
  }

  void updateNotification(String column, KissWatchNotifModel peopleWhoKissWatched) {
    _firestore.collection(column)
        .document(peopleWhoKissWatched.notificationId)
        .updateData({ "isWatched" : peopleWhoKissWatched.isWatched });
  }
}