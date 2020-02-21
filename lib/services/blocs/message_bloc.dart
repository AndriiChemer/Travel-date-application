import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';
import 'package:travel_date_app/services/repository/new_messages_repository.dart';

class MessageBloc extends BlocBase {

  bool _hasMore = true;
  bool _isLoading = false;
  int documentLimit = 10;
  int lastVisibleItemIndex = -1;
  DocumentSnapshot lastDocument;

  final _messageRepository = MessageRepository();
  final _newMessageRepository = NewMessagesRepository();

  final _showProgress = BehaviorSubject<bool>();
  final _messages = BehaviorSubject<List<MessageModel>>();
  var newMessageController = BehaviorSubject<int>.seeded(-1);

  Observable<bool> get showProgress => _showProgress.stream;
  Stream<List<MessageModel>> get messages => _messages.stream;
  Stream<int> get mewMessageIndex => newMessageController.stream;

  setNewMessageIndex(int index) {
    lastVisibleItemIndex = index;
    newMessageController.sink.add(index);
  }

  Stream<QuerySnapshot> getStreamMessagesByGroupChatId(String groupChatId, int newMessageLength) {
    int docLimit = newMessageLength <= 20 ? 20 : newMessageLength;

    Stream<QuerySnapshot> tempStream = _messageRepository.getStreamMessagesByGroupChatId(groupChatId, docLimit);
    Stream<QuerySnapshot> stream = tempStream;
    tempStream.listen((querySnapshot) {
      int documentsLength = querySnapshot.documents.length;
      if(documentsLength > 0) {
        lastDocument = querySnapshot.documents[documentsLength - 1];
      }
    });
    return stream;
  }

  Stream<QuerySnapshot> getNewMessageCounter(String userId) {
    return _messageRepository.getStreamNewMessageCount(userId);
  }

  void getMessages(String groupChatId) {
    print("MessageBloc");
    print("getMessages groupChatId = $groupChatId");

    if(!_hasMore) {
      print('No More Users');
      return;
    }

    if(_isLoading) {
      return;
    }

    _handleProgress(_isLoading);

    _messageRepository.getMessagesByGroupChatId(groupChatId, lastDocument, documentLimit).then((querySnapshot) {
      print("getMessages Success");

      List<MessageModel> usersList = messagesConverter(querySnapshot.documents);
      if(usersList.length > 0) {
        _messages.add(usersList);
      }



      int documentsLength = querySnapshot.documents.length;
      lastDocument = querySnapshot.documents[documentsLength - 1];

      if (documentsLength < documentLimit) {
        _hasMore = false;
      }
    });
  }

  void _handleProgress(bool isLoading) {
    _showProgress.add(isLoading);
    _isLoading = isLoading;
  }

  @override
  void dispose() async {
    await _messages.drain();
    _messages.close();

    super.dispose();
  }

  List<MessageModel> messagesConverter(List<DocumentSnapshot> documents) {
    List<MessageModel> messages = [];

    documents.forEach((document) {
      MessageModel message = MessageModel.fromMap(document.data);

      messages.add(message);
    });

    return messages;
  }

  void updateMessage(MessageModel message, String userId) {
    _messageRepository.updateMessage(message);
    _newMessageRepository.decrementCounter(userId);
  }
}