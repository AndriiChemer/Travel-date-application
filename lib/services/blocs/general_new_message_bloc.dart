import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_date_app/services/repository/new_messages_repository.dart';

class GeneralNewMessageBloc extends BlocBase {

  final _newMessagesRepository = NewMessagesRepository();


  Stream<DocumentSnapshot> getNewMessageCount(String userId) {
    return _newMessagesRepository.getNewMessageCount(userId);
  }

}