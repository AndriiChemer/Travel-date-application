import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/services/repository/message_repository.dart';

class MessageBloc extends BlocBase {

  bool _hasMore = true;
  bool _isLoading = false;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;

  final _messageRepository = MessageRepository();

  final _showProgress = BehaviorSubject<bool>();
  final _messages = BehaviorSubject<List<MessageModel>>();

  Observable<bool> get showProgress => _showProgress.stream;
  Stream<List<MessageModel>> get messages => _messages.stream;

  Stream<QuerySnapshot> getStreamMessagesByGroupChatId(String groupChatId) {
    return _messageRepository.getStreamMessagesByGroupChatId(groupChatId, 20);
  }
  Stream<QuerySnapshot> getMess() {
    return Firestore.instance
        .collection('messages')
        .document("123")
        .collection('123')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
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
      _messages.add(usersList);


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

      print("messages = ${message.toJson().toString()}");

      messages.add(message);
    });

    return messages;
  }
}