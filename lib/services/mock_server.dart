class MockServer {

  static Future<bool> checkVerifyCode(String digits) async {
    String serverCode = "1111";
    Future.delayed(Duration(seconds: 3), () {
      if (digits == serverCode) {
        return true;
      } else {
        return false;
      }
    });
  }
}