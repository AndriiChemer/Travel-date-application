import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {

  String key = 'LifecycleEventHandler';

  UserPreferences _userPreferences = UserPreferences();
  UserRepository _userRepository = UserRepository();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('\n\n');
    print('==================================================');
    _userPreferences.getUserId().then((userId) {
      if(userId != null) {
        switch(state) {
          case AppLifecycleState.detached:
            break;
          case AppLifecycleState.resumed:
            _handleUserOnlineState(userId, true);
            print('AppLifecycleState.resumed');
            break;
          case AppLifecycleState.inactive:
            break;
          case AppLifecycleState.paused:
            _handleUserOnlineState(userId, false);
            print('AppLifecycleState.paused');
            break;
        }
      }
    });
    print('==================================================');
    print('\n\n');

    super.didChangeAppLifecycleState(state);
  }

  _handleUserOnlineState(String userID, bool isOnline) {
    _userRepository.handleOnlineState(userID, isOnline);
  }
}
