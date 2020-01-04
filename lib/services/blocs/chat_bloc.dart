import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:travel_date_app/services/repository/chat_repository.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';

class ChatBloc extends BlocBase {

  final _chatRepository = ChatRepository();
  final _messageRepository = MessageRepository();


}