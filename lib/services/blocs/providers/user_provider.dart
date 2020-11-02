import 'package:flutter/material.dart';
import 'package:travel_date_app/services/blocs/user_bloc.dart';

class UserBlocProvider extends InheritedWidget {

  final bloc = UserBloc();

  UserBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static UserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserBlocProvider>().bloc;
  }
}