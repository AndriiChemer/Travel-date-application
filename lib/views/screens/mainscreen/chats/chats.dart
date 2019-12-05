import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';
import 'package:travel_date_app/views/widgets/chat_widget.dart';


//TODO add Bloc stream for getting chat by id
class ChatListScreen extends StatefulWidget {

 UserModel user;


 ChatListScreen({@required this.user});

 @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var searchTextFieldController = TextEditingController();

  List<ChatModel> chatModels = [];

  @override
  void initState() {
    MockServer.getChats().then((chatList) {
      setState(() {
        chatModels.addAll(chatList);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mainBackground,
      body: Container(
        child: Column(
          children: <Widget>[
            _searchTextField(),
            _divider(context),
            _listItems(context),
          ],
        ),
      ),
    );
  }

  Widget _listItems(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          _usersInChat(),
          _divider(context),
        for(ChatModel chat in chatModels)
          ChatItem(chat, widget.user),
        ],
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: TextFormField(
        autofocus: false,
        controller: searchTextFieldController,
        style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: Strings.search,
            prefixIcon: Icon(Icons.search, color: Colors.grey[800],),
            contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.7),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.7),
            )
        ),
      ),
    );
  }

  Widget _usersInChat() {
    return FutureBuilder(
      future: MockServer.getPeoplesForDiscoversScreen(),
      builder: (context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return _loading();
        } else {

          List<UserModel> users = snapshot.data;
          int itemCount = users.length;

          return Container(
            margin: EdgeInsets.only(left: 20, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("Matches", style: TextStyle(color: Colors.white, fontSize: 24),),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 90,
                    child: ListView.builder(
                        itemCount: itemCount,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return _circleImage(users[index]);
                        }
                    ),
                  ),
                ],
            ),
          );
        }
      },
    );
  }

  Widget _loading() {
    return Container(
      height: 90,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.yellow[800],
          size: 30,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  Widget _circleImage(UserModel user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: user,)));
      },

      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20, right: 20),
        child: Stack(
          children: <Widget>[
            Container(
              width: 60,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.imageUrl)
                  )
              ),
            ),
            _goldCircle(user.isOnline)
          ],
        ),
      ),
    );
  }

  Widget _goldCircle(bool isOnline) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: 16,
        height: 16,
        margin: EdgeInsets.only(left: 45),
        decoration: BoxDecoration(
            color: isOnline ? Colors.yellow[800] : Colors.white,
            shape: BoxShape.circle
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.white.withOpacity(0.8),
    );
  }
}
