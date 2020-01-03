
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class UsersByLocationBloc extends BlocBase {
  UsersByLocationBloc();

  bool _hasMore = true;
  bool _isLoading = false;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;

  final _userRepository = UserRepository();

  final _showProgress = BehaviorSubject<bool>();
  final _isEmptyUsersByLocation = BehaviorSubject<bool>();
  final _usersQuerySnapshot = BehaviorSubject<List<DocumentSnapshot>>();
  final _users = BehaviorSubject<List<UserModel>>();

  Observable<bool> get showProgress => _showProgress.stream;
  Observable<bool> get isEmptyUsersByLocation => _isEmptyUsersByLocation.stream;
  Stream<List<DocumentSnapshot>> get usersQuerySnapshot => _usersQuerySnapshot.stream;
  Stream<List<UserModel>> get users => _users.stream;

  Function(bool) get showProgressBar => _showProgress.sink.add;

  void getUsersByLocation(String city) {
    print("UsersByLocationBloc");
    print("getUsersByLocation");

    if(!_hasMore) {
      print('No More Users');
      return;
    }

    if(_isLoading) {
      return;
    }
    
    _handleProgress(_isLoading);

    _userRepository.getUsersByLocation(city, lastDocument, documentLimit).then((querySnapshot) {
      print("getUsersByLocation Success");

      List<DocumentSnapshot> usersListDocumentSnapshot = querySnapshot.documents;
      List<UserModel> usersList = usersConverter(usersListDocumentSnapshot);

      _users.add(usersList);
      _usersQuerySnapshot.add(usersListDocumentSnapshot);

      int documentsLength = usersListDocumentSnapshot.length;
      lastDocument = usersListDocumentSnapshot[documentsLength - 1];

      if (documentsLength < documentLimit) {
        _hasMore = false;
      }

      _handleProgress(false);
    }).catchError((onError) {
      _handleProgress(false);


      if(onError is PlatformException) {
        _isEmptyUsersByLocation.add(true);
      }

      _handleProgress(false);

      print("getUsersByLocation onError = ${onError.toString()}");
      _usersQuerySnapshot.addError(onError);
    });
  }

  void getUsers() {
    print("UsersByLocationBloc");
    print("getUsers");

    _userRepository.getUsers(lastDocument, documentLimit).then((querySnapshot) {
      print("getUsers  Success");
      List<DocumentSnapshot> usersListDocumentSnapshot = querySnapshot.documents;
      List<UserModel> usersList = usersConverter(usersListDocumentSnapshot);

      _users.add(usersList);
      _usersQuerySnapshot.add(usersListDocumentSnapshot);

      int documentsLength = usersListDocumentSnapshot.length;
      lastDocument = usersListDocumentSnapshot[documentsLength - 1];

      if (documentsLength < documentLimit) {
        _hasMore = false;
      }

      _handleProgress(false);
    }).then((onError) {
      _handleProgress(false);

      print("getUsers onError = ${onError.toString()}");
      _usersQuerySnapshot.addError(onError);
    });
  }
  
  void _handleProgress(bool isLoading) {
    _showProgress.add(isLoading);
    _isLoading = isLoading;
  }

  List<UserModel> usersConverter(List<DocumentSnapshot> listDocumentSnapshot) {
    List<UserModel> users = [];
    listDocumentSnapshot.forEach((document) {
      UserModel user = UserModel.fromMap(document.data);

      print("user = ${user.toJson().toString()}");

      users.add(user);
    });

    return users;
  }

  @override
  void dispose() async {
    await _users.drain();
    _users.close();
    await _showProgress.drain();
    _showProgress.close();
    await _usersQuerySnapshot.drain();
    _usersQuerySnapshot.close();

    super.dispose();
  }
}