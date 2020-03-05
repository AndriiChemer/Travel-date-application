
import 'package:flutter/widgets.dart';

import '../general_new_message_bloc.dart';

class GeneralNewMessageBlocProvider  extends InheritedWidget {
  final bloc = GeneralNewMessageBloc();

  GeneralNewMessageBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static GeneralNewMessageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GeneralNewMessageBlocProvider>().bloc;
  }
}