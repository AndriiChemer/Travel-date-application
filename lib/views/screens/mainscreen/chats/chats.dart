import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var searchTextFieldController = TextEditingController();

//  List<UserModel> users = [];

  @override
  void initState() {
    MockServer.getPeoplesForDiscoversScreen().then((userList) {
      setState(() {
//        users.addAll(userList);
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
            _usersInChat(),
          ],
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
            height: 90,
            child: ListView.builder(
                itemCount: itemCount,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return _circleImage(users[index]);
                }
            ),
          );


        }
      },
    );
  }

  Widget _loading() {
    return Container(
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
        margin: EdgeInsets.only(left: 20, top: 10, bottom: 10),
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
}
