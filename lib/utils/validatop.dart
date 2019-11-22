class CheckFields {
//https://medium.com/@nitishk72/form-validation-in-flutter-d762fbc9212c
  String isNameValid(String name) {
    if(name != null) {
      return null;
    } else {
      return "Must not be empty";
    }
  }

  String isEmailValid(String email) {
    if(email != null) {
      return null;
    } else {
      return "Must not be empty";
    }
  }

  String isPhoneValid(String phone) {
    if(phone != null) {
      return null;
    } else {
      return "Must not be empty";
    }
  }

}