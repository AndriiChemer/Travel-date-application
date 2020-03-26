import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/notification.dart';
import 'package:travel_date_app/services/repository/columns.dart';
import 'package:travel_date_app/services/repository/notification_repository.dart';

class KissedWatchedBloc {

  bool _hasMore = true;
  bool _isLoading = false;

  int documentLimit = 10;
  int lastVisibleItemIndex = -1;
  DocumentSnapshot lastDocument;

  final _notificationRepository = NotificationRepository();

  final _showProgress = BehaviorSubject<bool>();
  final _kissWatchedNotifications = BehaviorSubject<List<KissWatchNotifModel>>();
  var _newNotificationIndexController = BehaviorSubject<int>.seeded(-1);

  Observable<bool> get showProgress => _showProgress.stream;
  Stream<List<KissWatchNotifModel>> get kissWatchNotification => _kissWatchedNotifications.stream;
  Stream<int> get notificationIndex => _newNotificationIndexController.stream;

  setNewNotificationIndex(int index) {
    lastVisibleItemIndex = index;
    _newNotificationIndexController.sink.add(index);
  }

  Stream<QuerySnapshot> getNewAccountWatchedCounter(String userId) {
    return _notificationRepository.getWatchedAccountNotificationCount(userId);
  }

  Stream<QuerySnapshot> getNewAccountKissedCounter(String userId) {
    return _notificationRepository.getKissNotificationCount(userId);
  }

  void getKissedWatchedNotification(String userId, String column) {
    print("get$column");

    if(!_hasMore) {
      print('No More $column notifications');
      return;
    }

    if(_isLoading) {
      return;
    }

    _handleProgress(_isLoading);

    _notificationRepository.getKissedWatchedNotification(userId, column, lastDocument, documentLimit).then((querySnapshot) {
      List<KissWatchNotifModel> notificList = notifConverter(querySnapshot.documents);

      if(notificList.length > 0) {
        _kissWatchedNotifications.add(notificList);
      }

      int documentsLength = querySnapshot.documents.length;
      if(documentsLength > 0) {
        lastDocument = querySnapshot.documents[documentsLength - 1];
      }

      if (documentsLength < documentLimit) {
        _hasMore = false;
      }
    });
  }

  void _handleProgress(bool isLoading) {
    _showProgress.add(isLoading);
    _isLoading = isLoading;
  }

  List<KissWatchNotifModel> notifConverter(List<DocumentSnapshot> documents) {
    List<KissWatchNotifModel> notifications = [];

    documents.forEach((document) {
      KissWatchNotifModel model = KissWatchNotifModel.fromMap(document.data);

      notifications.add(model);
    });

    return notifications;
  }

  void dispose() async {
    await _kissWatchedNotifications.drain();
    _kissWatchedNotifications.close();

    await _newNotificationIndexController.drain();
    _newNotificationIndexController.close();
  }

  resetStream() {
    _hasMore = true;
    lastDocument = null;
    _showProgress.value = false;
    _kissWatchedNotifications.value = [];
  }

  void sendKiss(String yourId, String userId) {
    sendWatchKissedNotification(yourId, userId, Columns.KISSED_COLUMN);
  }

  void sendWatch(String yourId, String userId) {
    sendWatchKissedNotification(yourId, userId, Columns.WATCHED_COLUMN);
  }

  void sendWatchKissedNotification(String yourId, String userId, String column) async {
    var notificationCreatedAt = DateTime.now().millisecondsSinceEpoch * 1000;
    _notificationRepository.getNotificationByIds(column, yourId, userId).then((notificationsSnapshot){

      if (notificationsSnapshot == null || notificationsSnapshot.documents.length == 0) {

        _notificationRepository.sendWatchKissedNotification(column, yourId, userId, notificationCreatedAt, false)
            .then((notification) {
              _notificationRepository.setNotificationId(column, userId, notification.documentID);
            });

      } else {
        String notificationId = notificationsSnapshot.documents[0].data["notificationId"];
        _notificationRepository.resendNotification(column, notificationId, notificationCreatedAt);
      }
    });
  }

  void updateNotification(String column, KissWatchNotifModel peopleWhoKissWatched) {
    _notificationRepository.updateNotification(column, peopleWhoKissWatched);
  }
}