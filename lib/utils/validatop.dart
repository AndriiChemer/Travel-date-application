import 'dart:math';

import 'package:email_validator/email_validator.dart';

class ValidateFields {

  static bool isStringUrl(String str) {
    return Uri.parse(str).isAbsolute;
  }

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

  static String isPasswordValid(String password) {
    if(password.length == 0) {
      return "Please enter the Password";
    }

    if (calculateStrength(password) >= 4) {
      return null;
    } else {
      return "Your password must have at least 1 capital letter, \na small letter, "
          "a number and a length of at least 8 characters \nand may contain a special character.";
    }
  }

  static String emailOrPasswordValidate(String emailOrPassword) {
    if(emailOrPassword != null && emailOrPassword.isNotEmpty) {
      return null;
    } else {
      return "Please enter name";
    }
  }



//  static int getPercentageStrength(String s) {
//    switch (calculateStrength(s)) {
//      case 1:
//        return 25;
//      case 2:
//        return 50;
//      case 3:
//        return 75;
//      case 4:
//        return 100;
//      default:
//        return 0;
//    }
//  }

  static int calculateStrength(String password) {
    int strength = 0;

    if (hasAtLeastOneLowercaseLetter(password)) {
      strength++;
    }
    if (hasAtLeastOneUppercaseLetter(password)) {
      strength++;
    }
    if (hasAtLeastOneDigit(password)) {
      strength++;
    }
    if (hasAtLeastSpecialCharacter(password)) {
      strength++;
    }

    if (hasAtLeastEightCharacters(password)) {
      return min(3, strength) + 1;

    } else {
      return min(3, strength);
    }
  }

  static bool hasAtLeastEightCharacters(String s) {
    String patttern = r'^.{8,}$';
    RegExp regExp = RegExp(patttern);

    return regExp.hasMatch(s);
  }

  static bool hasAtLeastOneDigit(String s) {
    String patttern = r"^.*[0-9]+.*$";
    RegExp regExp = RegExp(patttern);

    return regExp.hasMatch(s);
  }

  static bool hasAtLeastOneLowercaseLetter(String s) {
    String patttern = r"^.*[a-z]+.*$";
    RegExp regExp = RegExp(patttern);

    return regExp.hasMatch(s);
  }

  static bool hasAtLeastOneUppercaseLetter(String s) {
    String patttern = r"^.*[A-Z]+.*$";
    RegExp regExp = RegExp(patttern);

    return regExp.hasMatch(s);
  }

  static bool hasAtLeastSpecialCharacter(String s) {
    String patttern = r"^.*[@#$%^&+=]+.*$";
    RegExp regExp = RegExp(patttern);

    return regExp.hasMatch(s);
  }
}