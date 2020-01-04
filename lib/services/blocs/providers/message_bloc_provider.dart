import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';

class MessageBlocProvider extends InheritedWidget {
  final bloc = MessageBloc();

  MessageBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static MessageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MessageBlocProvider>().bloc;
  }
}