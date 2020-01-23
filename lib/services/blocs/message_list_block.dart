import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/message.dart';

//TODO task delete
class MessageListBloc extends BlocBase {
  MessageListBloc();

  var navController = BehaviorSubject<List<MessageModel>>.seeded(null);

  Stream<List<MessageModel>> get navStream => navController.stream;
  Sink<List<MessageModel>> get navSink => navController.sink;

  add(List<MessageModel> messageList) {
    navSink.add(messageList);
  }

  @override
  void dispose() {
    navController.close();
    super.dispose();
  }
}