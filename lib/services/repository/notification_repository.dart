import 'package:cloud_firestore/cloud_firestore.dart';

import 'columns.dart';

class NotificationRepository {
  final Firestore _firestore =  Firestore.instance;

  Stream<DocumentSnapshot> getNewMessageCount(String userId) {
    return _firestore
        .collection(Columns.NEW_MESSAGES_COLUMN)
        .document(userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getKissNotificationCount(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document('kiss')
        .collection(userId)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getKissNotification(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document('kiss')
        .collection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getWatchedAccountNotificationCount(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document('watched_account')
        .collection(userId)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getWatchedAccountNotification(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document('watched_account')
        .collection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}