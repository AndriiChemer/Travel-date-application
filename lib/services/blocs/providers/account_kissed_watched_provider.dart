import 'package:flutter/widgets.dart';

import '../account_kissed_watched_notification_bloc.dart';

class AccountKissedWatchedProvider extends InheritedWidget {

  final bloc = KissedWatchedNotificationsBloc();

  AccountKissedWatchedProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static KissedWatchedNotificationsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccountKissedWatchedProvider>().bloc;
  }
}