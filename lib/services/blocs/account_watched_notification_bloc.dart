import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/notification.dart';
import 'package:travel_date_app/services/repository/notification_repository.dart';

class AccountWatchedNotificationsBloc extends BlocBase {

  bool _hasMorePeopleWatched = true;
  bool _isLoading = false;

  int documentLimit = 10;
  int lastVisibleItemIndex = -1;
  DocumentSnapshot lastDocument;

  final _notificationRepository = NotificationRepository();

  final _showProgress = BehaviorSubject<bool>();
  final _watchedNotifications = BehaviorSubject<List<KissWatchNotifModel>>();

  Observable<bool> get showProgress => _showProgress.stream;
  Stream<List<KissWatchNotifModel>> get watched => _watchedNotifications.stream;

  void getWatched(String userId) {
    print("getKiss");

    if(!_hasMorePeopleWatched) {
      print('No More kiss notifications');
      return;
    }

    if(_isLoading) {
      return;
    }

    _handleProgress(_isLoading);

    _notificationRepository.getWatchedNotification(userId, lastDocument, documentLimit).then((querySnapshot) {
      List<KissWatchNotifModel> notificList = notifConverter(querySnapshot.documents);

      if(notificList.length > 0) {
        _watchedNotifications.add(notificList);
      }

      int documentsLength = querySnapshot.documents.length;
      lastDocument = querySnapshot.documents[documentsLength - 1];

      if (documentsLength < documentLimit) {
        _hasMorePeopleWatched = false;
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

  @override
  void dispose() async {
    await _watchedNotifications.drain();
    _watchedNotifications.close();

    super.dispose();
  }
}