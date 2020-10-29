import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/services/repository/chat_repository.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';
import 'package:travel_date_app/services/repository/new_messages_repository.dart';
import 'package:travel_date_app/views/widgets/chat_widget.dart';

class ChatBloc extends BlocBase {

  int documentLimit = 10;
  DocumentSnapshot lastDocument;

  /// Show progress
  var _showProgress = BehaviorSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  /// Show progress
  var _emptyContent = BehaviorSubject<bool>();
  Observable<bool> get emptyContent => _emptyContent.stream;

  final _chatRepository = ChatRepository();
  final _messageRepository = MessageRepository();
  final _newMessageRepository = NewMessagesRepository();

  Stream<QuerySnapshot> getStreamChatListByUserId(String userId) {
    Stream<QuerySnapshot> tempStream = _chatRepository.getStreamChatListByUserId(userId, 20);
    Stream<QuerySnapshot> stream = tempStream;
    tempStream.listen((querySnapshot) {
      int documentsLength = querySnapshot.documents.length;
      if(documentsLength > 0) {
        lastDocument = querySnapshot.documents[documentsLength - 1];
      }
    });
    return stream;
  }

  void createChat(String yourId, String userId, String grpChtId, String content, int contentType) {
    print("ChatBloc createChat");
    var chatId = grpChtId;
    var adminId = yourId;
    var ids = [Ids(yourId, 0, true), Ids(userId, 0, false)];

    var user1 = {
      yourId: true,
    };

    var user2 = {
      userId: true
    };

    List<Map<String, dynamic>> users = [user1, user2];

    int createdAt = DateTime.now().millisecondsSinceEpoch * 1000;

    var isChatActive = true;
    var messageModify = 0;
    var groupChatId = grpChtId;

    ChatModel chat = ChatModel(chatId, adminId,  ids, createdAt, null, isChatActive, messageModify, null, groupChatId, null, users);

    _chatRepository.createChat(chat).then((isCreated) {

      updateChat(yourId, grpChtId, content, contentType, userId);
    }).catchError((onError) {

    });

  }

  void updateChat(String yourId, String grpChtId, String content, int contentType, String userId) {
    print("ChatBloc updateChat");
    var lastMessageAt = DateTime.now().millisecondsSinceEpoch * 1000;

    _chatRepository.updateChat(grpChtId, content, lastMessageAt, contentType);
    _newMessageRepository.incrementCounter(userId);

    sendMessage(yourId, grpChtId, content, contentType, lastMessageAt, false);

  }

   void sendMessage(String yourId, String grpChtId, String content, int contentType, int lastMessageAt, bool isUserInChat) {
    print("ChatBloc sendMessage");
    //TODO task remove isUserInChat from parameter

    MessageModel message = MessageModel(yourId, grpChtId, grpChtId, lastMessageAt, content, contentType, false);
    _messageRepository.sendMessage(message)
        .then((onValue) {
      _messageRepository.setMessageId(onValue.documentID);
      print("Message has been sent successful");
    }).catchError((onError) {
      print("ChatBloc sendMessage");
      print('onError: ' + onError.toString());
    });

  }

  List<ChatModel> chatsConverter(List<DocumentSnapshot> documents) {
    List<ChatModel> chats = [];

    documents.forEach((document){
      print('Chat1');
      ChatModel chat = ChatModel.fromMap(document.data);

      chats.add(chat);
    });

    return chats;
  }

  void updateUserInRoom(bool isUserInRoom, String yourId, String groupCharId) {
    _chatRepository.updateUserInRoom(isUserInRoom, yourId, groupCharId);
  }

  void isShowProgress(bool isVisible) {
    _showProgress.add(isVisible);
  }

  void showEmptyContent(bool isVisible) {
    _emptyContent.add(isVisible);
  }

  // ignore: must_call_super
  void dispose() async {
    await _showProgress.drain();
    _showProgress.close();

    await _emptyContent.drain();
    _emptyContent.close();
  }
}