import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/providers/users_provider.dart';
import 'package:travel_date_app/services/blocs/users_bloc.dart';
import 'package:travel_date_app/utils/time.dart';
import 'package:travel_date_app/utils/user_utils.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';

import 'new_chat_widget.dart';

class ChatItem extends StatefulWidget {

  final ChatModel chatModel;
  final UserModel yourModel;


  ChatItem(this.chatModel, this.yourModel);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  UserModel userModel;
  UsersBloc _usersBloc;

  @override
  void didChangeDependencies() {
    _usersBloc = UsersBlocProvider.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String userId = _getUserIs(widget.yourModel.id);

    return GestureDetector(
      onTap: _openChat,
      child: Container(
        height: 120,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: StreamBuilder(
          stream: _usersBloc.getUserByIdStream(userId),
          initialData: null,
          builder: (context, snapshot) {

            if (!snapshot.hasData) {

              return _bindItem('', '', false);
            } else {

              userModel = _usersBloc.usersConverter(snapshot.data.documents).first;
              print("User model = ${userModel.toJson().toString()}");

              return _bindItem(userModel.name, userModel.imageUrl, userModel.isOnline);
            }
          },
        ),
      ),
    );
  }

  Widget _bindItem(String chatName, String chatImageUrl, bool isOnline) {
    return Column(
      children: <Widget>[
        _divider(context),
        SizedBox(height: 10,),
        _chatDetail(chatName, chatImageUrl, isOnline)
      ],
    );
  }

  Widget _chatDetail(String chatName, String chatImageUrl, bool isOnline) {
    return Row(
      children: <Widget>[
        _circleImage(chatImageUrl, isOnline),
        _chatInfo(chatName),
        _lastMessageAt(),
      ],
    );
  }

  Widget _chatInfo(String chatName) {
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

  Widget _circleImage(String chatImageUrl, bool isOnline) {
    return GestureDetector(
      onTap: _openUserDetails,
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
                      image: NetworkImage(chatImageUrl)
                  )
              ),
            ),
            _goldCircle(isOnline)
          ],
        ),
      ),
    );
  }

  Widget _goldCircle(bool isOnline) {
    return Align(
      alignment: Alignment.bottomRight,
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

  Widget _lastMessageAt() {
    String lastMessage = TimeUtils.readTimestamp(widget.chatModel.lastMessageAt);

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(lastMessage, style: TextStyle(color: Colors.white.withOpacity(0.7)),),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.grey,
    );
  }

  String _getUserIs(String yourId) {
    String anotherId = '';
    for(String id in widget.chatModel.ids) {
      if(yourId != id) {
        anotherId = id;
        break;
      }
    }

    return anotherId;
  }

  _openChat() {
    if(userModel != null) {
      String groupId = UserUtils.buildChatGroupId(widget.yourModel.id, userModel.id);

      Navigator.push(context, MaterialPageRoute(builder: (context) => NewChatScreen(yourModel: widget.yourModel, anotherModel: userModel, groupCharId: groupId)));//, ChatDetailScreen(widget.chatModel, widget.yourModel, userModel)));
    }
  }

  _openUserDetails() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: userModel,)));
  }
}
