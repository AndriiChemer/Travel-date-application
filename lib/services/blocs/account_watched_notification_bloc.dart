import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/services/repository/notification_repository.dart';

class AccountWatchedNotificationsBloc extends BlocBase {

  bool _hasMorePeopleWatched = true;

  int documentLimit = 10;
  int lastVisibleItemIndex = -1;
  DocumentSnapshot lastDocument;

  final _notificationRepository = NotificationRepository();

  var _newAccountWatchedController = BehaviorSubject<int>.seeded(-1);

  Stream<int> get newAccountWatchedIndex => _newAccountWatchedController.stream;

  @override
  void dispose() async {
    await _newAccountWatchedController.drain();
    _newAccountWatchedController.close();

    super.dispose();
  }
}