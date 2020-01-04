import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/blocs/chat_bloc.dart';

class ChatBlocProvider extends InheritedWidget {
  final bloc = ChatBloc();

  ChatBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ChatBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatBlocProvider>().bloc;
  }
}