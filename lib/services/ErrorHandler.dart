import 'package:flutter/services.dart';
import 'package:travel_date_app/utils/strings.dart';

class ErrorHandler {

  static String getErrorMessage(onError) {
    if(onError is PlatformException) {
      return _getMessageByCode(onError.code);
    } else {
      return onError.toString();
    }
  }

  static String _getMessageByCode(String code) {
    if(code == "ERROR_INVALID_EMAIL") {
      return Strings.badly_email_format;
    } else if(code == "ERROR_WRONG_PASSWORD") {
      return Strings.badly_password;
    }
    return Strings.general_error;
  }
}