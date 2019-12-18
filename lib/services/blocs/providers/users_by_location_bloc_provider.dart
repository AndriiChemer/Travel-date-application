
import 'package:flutter/widgets.dart';

import '../users_by_location_bloc.dart';

class UsersByLocationBlocProvider extends InheritedWidget{

  final bloc = UsersByLocationBloc();

  UsersByLocationBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static UsersByLocationBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UsersByLocationBlocProvider>().bloc;
  }
}