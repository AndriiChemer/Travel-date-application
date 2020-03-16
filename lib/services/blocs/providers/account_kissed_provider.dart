import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/blocs/kiss_notification_bloc.dart';

class AccountKissedProvider extends InheritedWidget {
  final bloc = KissNotificationsBloc();

  AccountKissedProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static KissNotificationsBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccountKissedProvider>().bloc;
  }
}