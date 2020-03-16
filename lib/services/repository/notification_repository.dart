import 'package:cloud_firestore/cloud_firestore.dart';

import 'columns.dart';

class NotificationRepository {
  final Firestore _firestore =  Firestore.instance;

  final String KISS_DOCUMENT = 'kissed';
  final String WATCH_DOCUMENT = 'watched';

  //==========================Kissed============================================
  Future<QuerySnapshot> getKissNotification(
      String userId,
      DocumentSnapshot lastDocument,
      int documentLimit) async {

    QuerySnapshot querySnapshot;

    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(KISS_DOCUMENT)
          .collection(userId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(KISS_DOCUMENT)
          .collection(userId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .getDocuments();

    }
    return querySnapshot;
  }

  Stream<QuerySnapshot> getKissNotificationCount(String userId) {
    return _firestore.collection(Columns.NOTIFICATION_COLUMN)
        .document(KISS_DOCUMENT)
        .collection(userId)
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  //===============================Watched======================================
  Future<QuerySnapshot> getWatchedNotification(
      String userId,
      DocumentSnapshot lastDocument,
      int documentLimit) async {

    QuerySnapshot querySnapshot;

    if(lastDocument == null) {

      querySnapshot = await _firestore
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(WATCH_DOCUMENT)
          .collection(userId)
          .where("createdAt", isLessThan: lastDocument.data['createdAt'] as int ?? 0)
          .orderBy('createdAt', descending: true)
          .limit(documentLimit)
          .getDocuments();

    } else {

      querySnapshot = await _firestore
          .collection(Columns.NOTIFICATION_COLUMN)
          .document(WATCH_DOCUMENT)
          .collection(userId)
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
        .where("isWatched", isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
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