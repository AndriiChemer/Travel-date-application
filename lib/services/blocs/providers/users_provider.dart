
import 'package:flutter/widgets.dart';

import '../users_bloc.dart';

class UsersBlocProvider extends InheritedWidget {

  final bloc = UsersBloc();

  UsersBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static UsersBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UsersBlocProvider>().bloc;
  }
}