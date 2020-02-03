import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/chat_bloc.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/chat_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/providers/message_bloc_provider.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/time.dart';

class NewChatScreen extends StatefulWidget {

  final UserModel yourModel;
  final UserModel anotherModel;
  final String groupCharId;

  NewChatScreen({this.yourModel, this.anotherModel, this.groupCharId});

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ChatBloc _chatBloc;
  MessageBloc _messageBloc;

  final FocusNode focusNode = new FocusNode();
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textEditingController = new TextEditingController();

  bool isShowSticker = false;
  bool isChatNew = false;
  bool isLoading = false;
  String imageUrl = '';

  List<MessageModel> listMessage = [];

  @override
  void didChangeDependencies() {
    _chatBloc = ChatBlocProvider.of(context);
    _messageBloc = MessageBlocProvider.of(context);

    addScrollListener();
    addStreamListener();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    print("groupCharId = ${widget.groupCharId}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(context),
      backgroundColor: CustomColors.mainBackground,
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                (isShowSticker ? buildSticker() : Container()),

                // Input content
                buildInput(),
              ],
            ),
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
//                onPressed: getImage,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Color(0xff203152), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Color(0xff203152)),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff203152),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Color(0xff203152), width: 0.5)), color: Colors.white),
    );
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      if(isChatNew) {
        _chatBloc.createChat(widget.yourModel.id, widget.anotherModel.id, widget.groupCharId, content, type);
      } else {
        _chatBloc.updateChat(widget.yourModel.id, widget.groupCharId, content, type);
      }

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Nothing to send");
      //TODO show message
    }
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Colors.green, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: _messageBloc.getStreamMessagesByGroupChatId(widget.groupCharId),
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Container());//CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800])));
          } else {

            List<MessageModel> messages = _messageBloc.messagesConverter(snapshot.data.documents);
            if(messages.length == 0) {
              isChatNew = true;
            } else {
              isChatNew = false;
            }

            addToMainMessageList(messages, true);

            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, listMessage[index]),
              itemCount: listMessage.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
//      Firestore.instance.collection('users').document(id).updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  Widget buildItem(int index, MessageModel messageModel) {
    double maxScroll = listScrollController.position.maxScrollExtent;
    double currentScroll = listScrollController.position.pixels;
    double delta = MediaQuery.of(context).size.height * 0.2;

    print("maxScroll = $maxScroll");
    print("currentScroll = $currentScroll");
    print("delta = $delta");

    if (messageModel.userId == widget.yourModel.id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          messageModel.type == 0
          // Text
              ? Container(
            child: Text(
              messageModel.content,
              style: TextStyle(color: Color(0xff203152)),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
              : messageModel.type == 1
          // Image
              ? Container(
            child: FlatButton(
              child: Material(
                child: _loadImageContent(messageModel.content),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                //TODO task add open image full screen
//                Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: messageModel.content)));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
          // Sticker
              : Container(
            child: new Image.asset(
              'images/${messageModel.content}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                  child: _anotherUserImage(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
                messageModel.type == 0
                    ? Container(
                  child: Text(
                    messageModel.content,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Color(0xff203152), borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : messageModel.type == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: _peerImageMessage(messageModel.content),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
//                        Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: new Image.asset(
                    'images/${messageModel.content}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                TimeUtils.readTimestamp(messageModel.createdAt),
                style: TextStyle(color: Color(0xffaeaeae), fontSize: 12.0, fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].userId == widget.yourModel.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget _loadImageContent(String imageUrl) {
//    return CachedNetworkImage(
//      imageUrl: imageUrl,
//      width: 200.0,
//      height: 200.0,
//      fit: BoxFit.cover,
//      placeholder: (context, url) => Container(
//        child: CircularProgressIndicator(
//          valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
//        ),
//        width: 200.0,
//        height: 200.0,
//        padding: EdgeInsets.all(70.0),
//        decoration: BoxDecoration(
//          color: Color(0xffE8E8E8),
//          borderRadius: BorderRadius.all(
//            Radius.circular(8.0),
//          ),
//        ),
//      ),
//      errorWidget: (context, url, error) => Material(
//        child: Image.asset(
//          'images/img_not_available.jpeg',
//          width: 200.0,
//          height: 200.0,
//          fit: BoxFit.cover,
//        ),
//        borderRadius: BorderRadius.all(
//          Radius.circular(8.0),
//        ),
//        clipBehavior: Clip.hardEdge,
//      ),
//    );
    return Container(
      width: 150,
      height: 150,
      color: Colors.red,
    );
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].userId != widget.yourModel.id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget _anotherUserImage() {
    return Container(
      width: 35,
      height: 35,
      child: Image(image: NetworkImage(widget.anotherModel.imageUrl),),
//      imageUrl: widget.anotherUser.imageUrl,
//      placeholder: (context, url) => CircularProgressIndicator(),
    );
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

  Widget _peerImageMessage(String imageUrl) {
//    return CachedNetworkImage(
//      placeholder: (context, url) => Container(
//        child: CircularProgressIndicator(
//          valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
//        ),
//        width: 200.0,
//        height: 200.0,
//        padding: EdgeInsets.all(70.0),
//        decoration: BoxDecoration(
//          color: Color(0xffE8E8E8),
//          borderRadius: BorderRadius.all(
//            Radius.circular(8.0),
//          ),
//        ),
//      ),
//      errorWidget: (context, url, error) => Material(
//        child: Image.asset(
//          'images/img_not_available.jpeg',
//          width: 200.0,
//          height: 200.0,
//          fit: BoxFit.cover,
//        ),
//        borderRadius: BorderRadius.all(
//          Radius.circular(8.0),
//        ),
//        clipBehavior: Clip.hardEdge,
//      ),
//      imageUrl: imageUrl,
//      width: 200.0,
//      height: 200.0,
//      fit: BoxFit.cover,
//    );

    return Container(
      height: 200,
      width: 200,
      color: Colors.blue,
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.secondaryBackground,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.yellow[800], width: 1)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _arrowBack(), //TODO set chat name
              Text(Strings.settings_toolbar, style: TextStyle(color: Colors.white, fontSize: 22),),
              Container(width: 30, height: 30,)
            ],
          ),
        )
      ],
    );
  }

  Widget _arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
    );
  }

  void addStreamListener() {
    _messageBloc.messages.listen((messages) {
      addToMainMessageList(messages, false);
    });
  }

  void addScrollListener() {
    listScrollController.addListener(() {
      print("addScrollListener");
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      print("maxScroll = $maxScroll");
      print("currentScroll = $currentScroll");
      print("delta = $delta");
      if(maxScroll - currentScroll <= delta) {
        _messageBloc.getMessages(widget.groupCharId);
      }
    });
  }

  void addToMainMessageList(List<MessageModel> messages, bool isFromStream) {
    print("==============================");
    print(messages.toString());
    print("length = ${messages.length}");
    print("==============================");

    List<MessageModel> sorted = [];
    print("addToMainMessageList");
    print("size = ${listMessage.length}");
    messages.forEach((message) {

      if(!contains(listMessage, message)) {
        print("!listMessage.contains(message) = ${!listMessage.contains(message)}");
        print("Message = ${message.toJson().toString()}");
        sorted.add(message);
      }
    });

    if(isFromStream) {
      listMessage.insertAll(0, sorted);
    } else {
      setState(() {
        listMessage.addAll(sorted);
      });
    }
  }

  bool contains(List<MessageModel> list, MessageModel message) {
    String compareObject = message.toJson().toString();

    for(MessageModel m in list) {
      if(m.toJson().toString() == compareObject) {
        return true;
      }
    }

    return false;
  }
}
