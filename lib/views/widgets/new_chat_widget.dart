import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/chat_bloc.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/chat_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/providers/message_bloc_provider.dart';
import 'package:travel_date_app/utils/colors.dart';

import 'app_bars.dart';
import 'message_item.dart';

class NewChatScreen extends StatefulWidget {

  final UserModel yourModel;
  final UserModel anotherModel;
  final String groupCharId;
  final int newMessageLength;

  NewChatScreen({this.yourModel, this.anotherModel, this.groupCharId, this.newMessageLength});

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

  bool isChatNew = false;
  bool isLoading = false;
  bool isLogsShow = false;
  bool isUserInChat = false;
  bool isShowSticker = false;
  bool isAllMessageUpdated = false;
  String imageUrl = '';

  List<MessageModel> listMessage = [];

  @override
  void didChangeDependencies() {
    _chatBloc = ChatBlocProvider.of(context);
    _messageBloc = MessageBlocProvider.of(context);

    addStreamListener();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    print("groupCharId = ${widget.groupCharId}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(title: widget.anotherModel.name,),
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

  void onSendMessage(String content, int type) {
    if(!isAllMessageUpdated) {
      updateAllNotWatchedMessages();
    }
    //TODO task set all messages as watched

    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      if(isChatNew) {
        _chatBloc.createChat(widget.yourModel.id, widget.anotherModel.id, widget.groupCharId, content, type);
      } else {
        _chatBloc.updateChat(widget.yourModel.id, widget.groupCharId, content, type, widget.anotherModel.id, isUserInChat);
      }

      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Nothing to send");
      //TODO show message
    }
  }

  Widget buildListMessage() {
    print("buildListMessage groupCharId = ${widget.groupCharId}");
    return Flexible(
      child: StreamBuilder(
        stream: _messageBloc.getStreamMessagesByGroupChatId(widget.groupCharId, widget.newMessageLength),
        initialData: null,
        builder: (context, snapshot) {

          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              print("ConnectionState.waiting = ${ConnectionState.waiting}");
              return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800])));
            case ConnectionState.active:
            default:
            print("ConnectionState.active = ${ConnectionState.active}");
            if (!snapshot.hasData) {

              print("Has messages = ${snapshot.hasData}");
              if(listMessage.length == 0) {
                print("Chat is new");
                isChatNew = true;
              }

              return Center(
                  child: Container());

            } else {
              List<MessageModel> messages = _messageBloc.messagesConverter(snapshot.data.documents);

              print("messages size is = ${messages.length}");
              if(messages.length == 0) {
                print("Chat is new");
                isChatNew = true;
              } else {
                print("Chat is exist");
                isChatNew = false;
                _chatBloc.updateUserInRoom(true, widget.yourModel.id, widget.groupCharId);
              }

              addToMainMessageList(messages, true);

              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => MessageItem(index: index, message: listMessage[index], yourModel: widget.yourModel, anotherModel: widget.anotherModel, listMessage: listMessage,),
                itemCount: listMessage.length,
                reverse: true,
                controller: listScrollController,
              );
            }

          }
        },
      ),
    );
  }

  void addStreamListener() {
    _messageBloc.messages.listen((messages) {
      addToMainMessageList(messages, false);
    });
  }

  void addToMainMessageList(List<MessageModel> messages, bool isFromStream) {
    List<MessageModel> sorted = [];
    MessageModel lastNotWatchedModel;

    int messagesCount = 0;
    int stickersCount = 0;
    int picturesCount = 0;

    messages.forEach((message) {

      if(!contains(listMessage, message)) {
        switch(message.type) {
          case 0: messagesCount++ ; break;
          case 1: picturesCount++ ; break;
          case 2: stickersCount++ ; break;
        }

        if(!message.isWatched && message.userId != widget.yourModel.id) {
          lastNotWatchedModel = message;
        }
        sorted.add(message);
      }
    });

    if(sorted.isNotEmpty) {
      if(isFromStream) {

        if(lastNotWatchedModel != null) {
          int lastVisibleIndex = sorted.indexOf(lastNotWatchedModel);
          print('addToMainMessageList if ===============================================');
          _messageBloc.setNewMessageIndex(lastVisibleIndex);
        } else {
          print('setMessageListWatched else ===============================================');
          _messageBloc.setNewMessageIndex(-1);
        }

        listMessage.insertAll(0, sorted);
        scrollToFirstNotWatchedMessage(messagesCount, stickersCount, picturesCount);

      } else {
        setState(() {
          listMessage.addAll(sorted);
        });
      }
    }
  }

  void scrollToFirstNotWatchedMessage(int messagesCount, int stickersCount, int picturesCount) {
    Future.delayed(Duration(seconds: 0), (){

      print("maxScrollExtent = ${listScrollController.position.maxScrollExtent}");

      if(messagesCount == 1 || messagesCount == 0) {
        double height = listScrollController.position.minScrollExtent;
        listScrollController.animateTo(height.toDouble(), duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
      } else {
        double height = listScrollController.position.maxScrollExtent;
        listScrollController.animateTo(height.toDouble(), duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
      }


      Future.delayed(Duration(milliseconds: 700), () {
        setMessageListWatched();
      });


      Future.delayed(Duration(seconds: 2), () {
        addScrollListener();
        scrollListenerWithItemCount();
      });
    });
  }

  void setMessageListWatched() {
    if(_messageBloc.lastVisibleItemIndex > -1) {
      double scrollOffset = listScrollController.position.pixels;
      double viewportHeight = listScrollController.position.viewportDimension;
      double maxScrollExtent = listScrollController.position.maxScrollExtent;
      double minScrollExtent = listScrollController.position.minScrollExtent;
      double scrollRange = maxScrollExtent -
          minScrollExtent;
      int firstVisibleItemIndex =
      (scrollOffset / (scrollRange + viewportHeight) * listMessage.length).floor();

      for(int i = firstVisibleItemIndex; i <= _messageBloc.lastVisibleItemIndex; i++) {
        if(!listMessage[i].isWatched && widget.yourModel.id != listMessage[i].userId) {
          listMessage[i].isWatched = true;
          updateMessage(listMessage[i]);
        }
      }

      Future.delayed(Duration(seconds: 2), (){
        print('setMessageListWatched ===============================================');
        _messageBloc.setNewMessageIndex(firstVisibleItemIndex - 1);
      });
    }
  }

  void scrollListenerWithItemCount() {
    listScrollController.addListener(() {
      print('scrollListenerWithItemCount');

      double scrollOffset = listScrollController.position.pixels;
      double viewportHeight = listScrollController.position.viewportDimension;
      double maxScrollExtent = listScrollController.position.maxScrollExtent;
      double minScrollExtent = listScrollController.position.minScrollExtent;
      double scrollRange = maxScrollExtent -
          minScrollExtent;
      int firstVisibleItemIndex =
      (scrollOffset / (scrollRange + viewportHeight) * listMessage.length).floor();

      if(firstVisibleItemIndex > -1) {
        MessageModel message = listMessage[firstVisibleItemIndex];


        if(firstVisibleItemIndex == 0 && message.isWatched) {
          print('scrollListenerWithItemCount if ===============================================');
          _messageBloc.setNewMessageIndex(-1);

        } else {
          if(!message.isWatched && message.userId != widget.yourModel.id) {
            message.isWatched = true;
            _messageBloc.updateMessage(message, widget.yourModel.id);

            print('scrollListenerWithItemCount else if ===============================================');
          }
          _messageBloc.setNewMessageIndex(firstVisibleItemIndex--);
        }

      } else {
        print('scrollListenerWithItemCount else ===============================================');
        _messageBloc.setNewMessageIndex(-1);
      }

      bool a = firstVisibleItemIndex > -1;
      print('firstVisibleItemIndex: ' + firstVisibleItemIndex.toString());
      print('firstVisibleItemIndex > -1' + a.toString());
      if(firstVisibleItemIndex > -1) {


        MessageModel message = listMessage[firstVisibleItemIndex];
        if(message.isWatched && message.userId != widget.yourModel.id) {
          print('scrollListenerWithItemCount another if ===============================================');
          _messageBloc.setNewMessageIndex(-1);
        }
      }
    });
  }

  void addScrollListener() {
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;

      if(maxScroll - currentScroll < -3) {
        // TODO task show progress load more messages
//        _messageBloc.getMessages(widget.groupCharId);
      }
    });
  }

  bool contains(List<MessageModel> list, MessageModel message) {

    for(MessageModel itemMessage in list) {
      if(itemMessage.content == message.content &&
          itemMessage.userId == message.userId &&
            itemMessage.createdAt == message.createdAt) {
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    _chatBloc.updateUserInRoom(false, widget.yourModel.id, widget.groupCharId);
    super.dispose();
  }

  void updateMessage(MessageModel message) {
    _messageBloc.updateMessage(message, widget.yourModel.id);
  }

  void updateAllNotWatchedMessages() {
    for(MessageModel message in listMessage) {
      if(!message.isWatched && widget.yourModel.id != message.userId) {
        _messageBloc.updateMessage(message, widget.yourModel.id);
      }
    }
     isAllMessageUpdated = true;
  }

}
