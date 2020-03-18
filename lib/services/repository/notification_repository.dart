import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/models/notification.dart';

import 'columns.dart';

class NotificationRepository {
  final Firestore _firestore =  Firestore.instance;

  static const String KISS_DOCUMENT = 'kissed';
  static const String WATCH_DOCUMENT = 'watched';

  //==========================Kissed============================================
//  Future<QuerySnapshot> getKissNotification(
//      String userId,
//      DocumentSnapshot lastDocument,
//      int documentLimit) async {
//
//    QuerySnapshot querySnapshot;
//
//    if(lastDocument == null) {
//
//      querySnapshot = await _firestore
//          .collection(Columns.NOTIFICATION_COLUMN)
//          .document(KISS_DOCUMENT)
//          .collection(userId)
//          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
//          .orderBy('createdAt', descending: true)
//          .limit(documentLimit)
//          .getDocuments();
//
//    } else {
//
//      querySnapshot = await _firestore
//          .collection(Columns.NOTIFICATION_COLUMN)
//          .document(KISS_DOCUMENT)
//          .collection(userId)
//          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
//          .orderBy('createdAt', descending: true)
//          .startAfterDocument(lastDocument)
//          .limit(documentLimit)
//          .getDocuments();
//
//    }
//    return querySnapshot;
//  }

  Stream<QuerySnapshot> getKissNotificationCount(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document(KISS_DOCUMENT)
        .collection(userId)
        .document(KISS_DOCUMENT)
        .collection(KISS_DOCUMENT)
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
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(column)
          .collection(userId)
          .document(column)
          .collection(column)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(column)
          .collection(userId)
          .document(column)
          .collection(column)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }

  Stream<QuerySnapshot> getWatchedAccountNotificationCount(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document(WATCH_DOCUMENT)
        .collection(userId)
        .document(WATCH_DOCUMENT)
        .collection(WATCH_DOCUMENT)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentReference> sendWatchKissedNotification(String column, String yourId, String userId, int notificationCreatedAt, bool isWatched) {
    var model = KissWatchNotifModel(yourId, '', notificationCreatedAt, isWatched);

    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document(column)
        .collection(userId)
        .document(column)
        .collection(column)
        .add(model.toJson());
  }

  void setNotificationId(String column, String userId, String documentID) {
    _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document(column)
        .collection(userId)
        .document(column)
        .collection(column)
        .document(documentID)
        .updateData({ "notificationId" : documentID });
  }

//  Stream<QuerySnapshot> getWatchedAccountNotification(String userId) {
//    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
//        .document('watched_account')
//        .collection(userId)
//        .orderBy('createdAt', descending: true)
//        .snapshots();
//  }
//
//  Stream<QuerySnapshot> getKissNotificationStream(String userId) {
//    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
//        .document(KISS_DOCUMENT)
//        .collection(userId)
//        .orderBy('createdAt', descending: true)
//        .snapshots();
//  }
}