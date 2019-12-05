import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/chat_user_info.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';

class ChatItem extends StatefulWidget {

  ChatModel chatModel;


  ChatItem(this.chatModel);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  String chatImage;
  UserModel userModel;

  @override
  void initState() {
    super.initState();
    chatImage = getChatImage();

    MockServer.getUserById(getUserId()).then((user){
      setState(() {
        userModel = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _circleImage()
        ],
      ),
    );
  }

  Widget _circleImage() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: userModel,)));
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
                      image: NetworkImage(getChatImage())
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

  String getChatImage() {
    if(widget.chatModel.usersInfo.length == 2) {
      if(widget.chatModel.usersInfo[0].userId != widget.chatModel.adminId) {
        return widget.chatModel.usersInfo[0].imageUrl;
      } else {
        return widget.chatModel.usersInfo[1].imageUrl;
      }
    } else {
      //TODO check for group
      return widget.chatModel.usersInfo.first.imageUrl;
    }
  }

  String getUserId() {
    if(widget.chatModel.usersInfo.length == 2) {
      if(widget.chatModel.usersInfo[0].userId != widget.chatModel.adminId) {
        return widget.chatModel.usersInfo[0].userId;
      } else {
        return widget.chatModel.usersInfo[1].userId;
      }
    } else {
      //TODO check for group
      return widget.chatModel.usersInfo.first.userId;
    }

  }
}
