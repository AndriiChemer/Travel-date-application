import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/services/repository/chat_repository.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';

class ChatBloc extends BlocBase {

  final _chatRepository = ChatRepository();
  final _messageRepository = MessageRepository();

  void createChat(String yourId, String userId, String grpChtId, String content, int contentType) {
    print("ChatBloc createChat");
    var chatId = grpChtId;
    var adminId = yourId;
    var ids = [yourId, userId];
    int createdAt = DateTime.now().millisecondsSinceEpoch * 1000;

    var isChatActive = true;
    var messageModify = 0;
    var groupChatId = grpChtId;

    ChatModel chat = ChatModel(chatId, adminId,  ids, createdAt, null, isChatActive, messageModify, null, groupChatId, null);

    _chatRepository.createChat(chat).then((isCreated) {

      updateChat(yourId, grpChtId, content, contentType);
    }).catchError((onError) {

    });

  }

  void updateChat(String yourId, String grpChtId, String content, int contentType) {
    print("ChatBloc updateChat");
    var lastMessageAt = DateTime.now().millisecondsSinceEpoch * 1000;

    _chatRepository.updateChat(grpChtId, content, lastMessageAt, contentType);

    sendMessage(yourId, grpChtId, content, contentType, lastMessageAt);

  }

  void sendMessage(String yourId, String grpChtId, String content, int contentType, int lastMessageAt) {
    print("ChatBloc sendMessage");

    MessageModel message = MessageModel(yourId, grpChtId, grpChtId, lastMessageAt, content, contentType);
    _messageRepository.sendMessage(message)
        .then((onValue) {
      print("Message has been sent successful");
    }).catchError((onError) {
      print("ChatBloc sendMessage");
      print('onError: ' + onError.toString());
    });

  }
}