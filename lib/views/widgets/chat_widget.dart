import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/chat_user_info.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/views/screens/chat/chatscreen.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';

class ChatItem extends StatefulWidget {

  final ChatModel chatModel;
  final UserModel yourModel;


  ChatItem(this.chatModel, this.yourModel);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

//  ChatUserInfo chatUserInfo;
  String chatImage;
  String chatName;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    chatName = "Chat";
    chatImage = '';

    MockServer.getUserById('').then((user){
      setState(() {
        userModel = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(widget.chatModel, widget.yourModel, userModel)));
      },
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: <Widget>[
            _divider(context),
            SizedBox(height: 10,),
            _chatDetail(),
            Row(
              children: <Widget>[
                _circleImage(),
                _chatInfo(),
                _dateLastMessage(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //TODO get user by id and show chat detail
  Widget _chatDetail() {
    return StreamBuilder();
  }

  Widget _chatInfo() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(chatName, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 22),),
            Text(widget.chatModel.lastMessage, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 20),)
          ],
        ),
      ),
    );
  }

  Widget _circleImage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: userModel,)));
      },

      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
        child: Stack(
          children: <Widget>[
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(chatImage)
                  )
              ),
            ),
            _goldCircle(userModel == null ? false : userModel.isOnline)
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

  Widget _dateLastMessage() {
    String lastMessage = readTimestamp(widget.chatModel.lastMessageAt);

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(lastMessage, style: TextStyle(color: Colors.white.withOpacity(0.7)),),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {

        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.grey,
    );
  }
}
