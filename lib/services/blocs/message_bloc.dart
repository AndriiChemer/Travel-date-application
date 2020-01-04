import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';

class MessageBloc extends BlocBase {

  int documentLimit = 10;
  DocumentSnapshot lastDocument;

  final _messageRepository = MessageRepository();

  final _messages = BehaviorSubject<List<MessageModel>>();

  Stream<List<MessageModel>> get messages => _messages.stream;

  void getMessages(String groupChatId) {
    print("MessageBloc");
    print("getMessages groupChatId = $groupChatId");
    _messageRepository.getMessagesByGroupChatId(groupChatId, lastDocument, documentLimit);
  }
}