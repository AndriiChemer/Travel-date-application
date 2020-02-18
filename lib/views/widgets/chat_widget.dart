import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/message_bloc_provider.dart';
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
  MessageBloc _messageBloc;

  @override
  void didChangeDependencies() {
    _usersBloc = UsersBlocProvider.of(context);
    _messageBloc = MessageBlocProvider.of(context);

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

              return Container();
            } else {

              userModel = _usersBloc.usersConverter(snapshot.data.documents).first;
              print("User model = ${userModel.toJson().toString()}");

              return _bindItem(userId, userModel.name, userModel.imageUrl, userModel.isOnline);
            }
          },
        ),
      ),
    );
  }

  Widget _bindItem(String id, String chatName, String chatImageUrl, bool isOnline) {
    return Column(
      children: <Widget>[
        _divider(context),
        SizedBox(height: 10,),
        _chatDetail(id, chatName, chatImageUrl, isOnline)
      ],
    );
  }

  Widget _chatDetail(String id, String chatName, String chatImageUrl, bool isOnline) {
    return Row(
      children: <Widget>[
        _circleImage(chatImageUrl, isOnline),
        _chatInfo(chatName),
        _lastMessageAt(id),
      ],
    );
  }

  Widget _chatInfo(String chatName) {
    int valueEnd = widget.chatModel.lastMessage.length > 17 ? 17 : widget.chatModel.lastMessage.length;
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(chatName, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 22),),
            Text("${widget.chatModel.lastMessage.substring(0, valueEnd)}...", style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 20),)
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

  Widget _lastMessageAt(String id) {
    String lastMessage = TimeUtils.readTimestamp(widget.chatModel.lastMessageAt);

     return Container(
       height: 70,
       padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
         Text(lastMessage, style: TextStyle(color: Colors.white.withOpacity(0.7)),),
         _newMessageCount(id)
         ],
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
    for(Ids id in widget.chatModel.ids) {
      if(yourId != id.userId) {
        anotherId = id.userId;
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

  //TODO task show new messages count in dialog
  Widget _newMessageCount(String id) {
    return id != '' ? StreamBuilder(
      stream: _messageBloc.getNewMessageCounter(id),
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          var newMessageCount = snapshot.data.documents.length;
          print("ANDRII new messages = $newMessageCount");
          return newMessageCount > 0 ? _circleNotification(newMessageCount) : Container();
        } else {

          return Container();
        }
      }
    ) : Container();
  }

  Widget _circleNotification(int newMessageCount) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 7, 5),//EdgeInsets.all(4),
      child: Text(newMessageCount.toString(), style: TextStyle(fontSize: 16, color: Colors.white),),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),

          color: Colors.red[900]),
    );

//    return ClipRRect(
//      borderRadius: BorderRadius.circular(8.0),
//      child: Text(170.toString(), style: TextStyle(fontSize: 16, color: Colors.white),),
//    );
  }
}
