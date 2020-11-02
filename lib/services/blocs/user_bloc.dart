import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';

class UserBloc extends BlocBase {

  final _userPreferences = UserPreferences();

  /// User from shared preference
  var _localUserController = BehaviorSubject<UserModel>();
  Stream<UserModel> get userStream => _localUserController.stream;
  Sink<UserModel> get _userSink => _localUserController.sink;

  void getUser() {
    _userPreferences.getUser().then((user) {
      _userSink.add(user);
    });
  }

  @override
  void dispose() async {
    await _localUserController.drain();
    _localUserController.close();

    super.dispose();
  }
}