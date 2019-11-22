import 'package:email_validator/email_validator.dart';

class ValidateFields {

  static String isNameValid(String name) {
    if(name != null && name.isNotEmpty) {
      return null;
    } else {
      return "Please enter name";
    }
  }

  static String isEmailValid(String email) {
    if(email != null && email.isNotEmpty) {
      if(EmailValidator.validate(email)) {
        return null;
      } else {
        return "Please enter valid email.\nEmail must look like mail@mail.domain";
      }
    } else {
      return "Please enter email";
    }
  }

  static String isPhoneValid(String phone) {
    String patttern = "[0-9]{8,13}w";
    RegExp regExp = new RegExp(patttern);

    if (phone.length == 0) {
      return 'Please enter mobile number';
    } else if(!regExp.hasMatch(phone) && phone.length > 13) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

}