import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/message_bloc_provider.dart';
import 'package:travel_date_app/utils/time.dart';

class MessageItem extends StatefulWidget {

  final int index;
  final MessageModel message;
  final UserModel yourModel;
  final UserModel anotherModel;
  final List<MessageModel> listMessage;

  const MessageItem({Key key, this.index, this.message, this.yourModel, this.anotherModel, this.listMessage}) : super(key: key);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {

  MessageBloc _messageBloc;

  @override
  void didChangeDependencies() {
    _messageBloc = MessageBlocProvider.of(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return buildItem();
  }

  Widget buildItem() {
    if (widget.message.userId == widget.yourModel.id) {

      return _buildMessageRow(true);
    } else {

      return Container(
        child: Column(
          children: <Widget>[
            _newMessageDivider(),
            _buildMessageRow(false),
            _buildUserImage()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget _buildMessage(bool isMyMessage) {
    return Container(
      child: Text(
        widget.message.content,
        style: TextStyle(
            color: isMyMessage ? Color(0xff203152) : Colors.white
        ),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(
          color: isMyMessage ? Color(0xffE8E8E8) : Color(0xff203152),
          borderRadius: BorderRadius.circular(8.0)
      ),
      margin: isMyMessage ? EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20.0 : 10.0, right: 10.0) : EdgeInsets.only(left: 10.0),
    );
  }

  Widget _buildSticker() {
    return Container(
      child: new Image.asset(
        'images/${widget.message.content}.gif',
        width: 100.0,
        height: 100.0,
        fit: BoxFit.cover,
      ),
      margin: EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20.0 : 10.0, right: 10.0),
    );
  }

  Widget _buildImage(bool isMyMessage) {
    return Container(
      child: FlatButton(
        child: Material(
          child: _loadImageMessage(widget.message.content),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          //TODO task add open image full screen
//                Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: messageModel.content)));
        },
        padding: EdgeInsets.all(0),
      ),
      margin: isMyMessage ? EdgeInsets.only(bottom: isLastMessageRight(widget.index) ? 20.0 : 10.0, right: 10.0) : EdgeInsets.only(left: 10.0),
    );
  }

  Widget _buildMessageRow(bool isMyMessage) {
    return Row(
      children: <Widget>[
        isMyMessage ? Container() : _anotherUserImage(),
        widget.message.type == 0 ? _buildMessage(isMyMessage) : widget.message.type == 1 ? _buildImage(isMyMessage) : _buildSticker(),
      ],
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
    );
  }

  Widget _buildUserImage() {
    return isLastMessageLeft(widget.index) ? Container(
      child: Text(
        TimeUtils.readTimestamp(widget.message.createdAt),
        style: TextStyle(color: Color(0xffaeaeae), fontSize: 12.0, fontStyle: FontStyle.italic),
      ),
      margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
    ) : Container();
  }

  Widget _newMessageDivider() {
    return StreamBuilder(
      stream: _messageBloc.newMessageController,
      builder: (context, snapshot) {
        return snapshot.data != null && snapshot.data > -1 && snapshot.data == widget.index ? Container(
          width: MediaQuery.of(context).size.width,
          height: 2,
          margin: EdgeInsets.only(bottom: 1.0, top: 5.0),
          color: Colors.red[900],
        ) : Container();
      },
    );
  }

  Widget _loadImageMessage(String imageUrl) {
    return Container(
      height: 200,
      width: 200,
      color: Colors.blue,
    );
  }

  Widget _anotherUserImage() {
    return isLastMessageLeft(widget.index)
        ? Material(
      child: Container(
          width: 35,
          height: 35,
          child: Image(image: NetworkImage(widget.anotherModel.imageUrl),),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(18.0),
      ),
      clipBehavior: Clip.hardEdge,
    )
        : Container(width: 35.0);

//    return Container(
//      width: 35,
//      height: 35,
//      child: Image(image: NetworkImage(widget.anotherModel.imageUrl),),
//      imageUrl: widget.anotherUser.imageUrl,
//      placeholder: (context, url) => CircularProgressIndicator(),
//    );
//    CachedNetworkImage(
//      placeholder: (context, url) => Container(
//        child: CircularProgressIndicator(
//          strokeWidth: 1.0,
//          valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
//        ),
//        width: 35.0,
//        height: 35.0,
//        padding: EdgeInsets.all(10.0),
//      ),
//      imageUrl: widget.anotherUser.imageUrl,
//      width: 35.0,
//      height: 35.0,
//      fit: BoxFit.cover,
//    );
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && widget.listMessage != null && widget.listMessage[index - 1].userId != widget.yourModel.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && widget.listMessage != null && widget.listMessage[index - 1].userId == widget.yourModel.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
