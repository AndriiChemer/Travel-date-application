import 'package:flutter/widgets.dart';

import '../account_watched_notification_bloc.dart';

class AccountWatchedProvider extends InheritedWidget {

  final bloc = AccountWatchedNotificationsBloc();

  AccountWatchedProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static AccountWatchedNotificationsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccountWatchedProvider>().bloc;
  }
}