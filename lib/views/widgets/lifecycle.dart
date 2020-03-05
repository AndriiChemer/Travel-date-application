import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  UserPreferences _userPreferences = UserPreferences();
  UserRepository _userRepository = UserRepository();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _userPreferences.getUserId().then((userId) {
      if(userId != null) {
        switch(state) {
          case AppLifecycleState.detached:
            break;
          case AppLifecycleState.resumed:
            print('AppLifecycleState.resumed = true');
            _handleUserOnlineState(userId, true);
            break;
          case AppLifecycleState.inactive:
            break;
          case AppLifecycleState.paused:
            print('AppLifecycleState.resumed = false');
            _handleUserOnlineState(userId, false);
            break;
        }
      }
    });
    super.didChangeAppLifecycleState(state);
  }

  _handleUserOnlineState(String userID, bool isOnline) {
    _userRepository.handleOnlineState(userID, isOnline);
  }
}
