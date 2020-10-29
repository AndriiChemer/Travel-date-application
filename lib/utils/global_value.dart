class GlobalValue {

  static const String instagramUrlLogin = 'https://api.instagram.com/oauth/authorize' +
        '?client_id=$appID' +
        '&redirect_uri=$redirectUrl' +
        '&scope=user_profile,user_media' +
        '&response_type=$code' +
        '?state=$state';

  static const String appID = '355485295785507';
  static const String secretID = '379c20a3735ef5d70f7046e3e9df70af';
  static const String redirectUrl = 'https://www.instagram.com';
  static const String code = '234';
  static const String state = '3';


}