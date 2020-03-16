import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/services/repository/notification_repository.dart';

class KissNotificationsBloc extends BlocBase {

  bool _hasMoreKisses = true;

  int documentLimit = 10;
  int lastVisibleItemIndex = -1;
  DocumentSnapshot lastDocument;

  final _notificationRepository = NotificationRepository();

  var _newKissController = BehaviorSubject<int>.seeded(-1);

  Stream<int> get newKissIndex => _newKissController.stream;


//  void getKiss(String groupChatId) {
//    print("MessageBloc");
//    print("getMessages groupChatId = $groupChatId");
//
//    if(!_hasMore) {
//      print('No More Users');
//      return;
//    }
//
//    if(_isLoading) {
//      return;
//    }
//
//    _handleProgress(_isLoading);
//
//    _messageRepository.getMessagesByGroupChatId(groupChatId, lastDocument, documentLimit).then((querySnapshot) {
//
//
//      List<MessageModel> usersList = messagesConverter(querySnapshot.documents);
//
//      if(usersList.length > 0) {
//        _messages.add(usersList);
//      }
//
//
//
//      int documentsLength = querySnapshot.documents.length;
//      lastDocument = querySnapshot.documents[documentsLength - 1];
//
//      if (documentsLength < documentLimit) {
//        _hasMore = false;
//      }
//    });
//  }


  @override
  void dispose() async {
    await _newKissController.drain();
    _newKissController.close();

    super.dispose();
  }
}