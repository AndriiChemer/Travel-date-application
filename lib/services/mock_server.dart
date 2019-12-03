import 'package:travel_date_app/models/person_model.dart';

class MockServer {

  static Future<bool> checkVerifyCode(String digits) async {
    String serverCode = "1111";
    Future.delayed(Duration(seconds: 2), () {
      if (digits == serverCode) {
        return true;
      } else {
        return false;
      }
    });
  }

  static Future<List<UserModel>> getPeoplesForDiscoversScreen() async {
    return Future.delayed(Duration(seconds: 2), () {
      return peopleList;
    });
  }

  static List<UserModel> peopleList = [
    UserModel(id: 1, name: "Andii Chemer", person: "Male", city: "Wroclaw", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/11039096_131093853921083_6660331166421982710_n.jpg?_nc_cat=105&_nc_ohc=9jTzqURUehAAQlFEkgY43DnXphv7njdmTviZd_kXWJOPc5ObcvoCqOwSA&_nc_ht=scontent-waw1-1.xx&oh=2bda72df6d9d225e7874a37c2ea9a158&oe=5E86847C",
          state: 0, status: "Diamond", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.099923, lng: 17.036116, description: description, isVerify: true),
    UserModel(id: 2, name: "Volodymyr", person: "Male", city: "Lublin", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t31.0-8/p960x960/22712153_813002642194857_7976803065891309368_o.jpg?_nc_cat=110&_nc_ohc=ObRDDb7hqhUAQmkFU99Yg7BW7hXCFXc9mhguWRGQanQdaE10rqQAsj4NA&_nc_ht=scontent-waw1-1.xx&oh=4c828c7399871db1b5018b8d95807343&oe=5E8BFE50",
      state: 0, status: "Gold", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.22531, lng: 22.6220, description: description, isVerify: false),
    UserModel(id: 3, name: "Viktoriia", person: "Female", city: "Wroclaw", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/60457709_864772787189123_3743945282803466240_n.jpg?_nc_cat=110&_nc_ohc=gTZApKPcEbUAQna2UNk3Y74FrmCtU4BXI59vVWQL5heNWY6W8pwYqyetA&_nc_ht=scontent-waw1-1.xx&oh=5b7fbf84f77bdc0aa18fe91f2da610c0&oe=5E83FAD9",
      state: 0, status: "Diamond", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.099923, lng: 17.036116, description: description, isVerify: true),
    UserModel(id: 4, name: "Maksym", person: "Male", city: "Wroclaw", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71813070_910727249327783_222159086056112128_n.jpg?_nc_cat=102&_nc_ohc=tGhwApO27W8AQkF9rJH620wLDEERszzT1hw-EUiHuCjkoJ-QvA-1YfSPQ&_nc_ht=scontent-waw1-1.xx&oh=08296a0a54da03239131e4693e36c617&oe=5E7CD684",
      state: 0, status: "Classic", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.099923, lng: 17.036116, description: description, isVerify: false),
    UserModel(id: 5, name: "Mariya", person: "Female", city: "Wroclaw", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/72976549_961800860825744_7338113352209530880_n.jpg?_nc_cat=108&_nc_ohc=C4tbIMGX1CwAQkW2iObE0m8k01BiscdgJ893JuWK-hkluh5IbkdNZOyZg&_nc_ht=scontent-waw1-1.xx&oh=461e530ece4f15eea46838a1b74b7b18&oe=5E8C6F67",
      state: 0, status: "Diamond", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.099923, lng: 17.036116, description: description, isVerify: false),
    UserModel(id: 6, name: "Ola", person: "Feale", city: "Wroclaw", imageUrl: "https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/70680428_3162489207126285_5475261275724316672_n.jpg?_nc_cat=110&_nc_ohc=ChH1_AQd1BUAQk7UFoq_B2olVhXZV7wpFJkjuT9auf_yk1YtnRJCYDkqg&_nc_ht=scontent-waw1-1.xx&oh=ebbd11e79d063fcb60ace9a64e9129ec&oe=5E829D5A",
      state: 0, status: "Diamond", dateCreated: "2019.11.26", lastTimeOnline: "2019.11.26", lat: 51.099923, lng: 17.036116, description: description, isVerify: false),
  ];

  static var description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

}