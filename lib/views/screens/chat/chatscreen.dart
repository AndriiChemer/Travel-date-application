import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/message.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/message_list_block.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';

class ChatDetailScreen extends StatefulWidget {

  ChatModel chatModel;
  UserModel yourModel;


  ChatDetailScreen(this.chatModel, this.yourModel);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MessageListBloc messageListBloc = BlocProvider.getBloc<MessageListBloc>();

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  bool isShowSticker = false;
  bool isLoading = false;
  String imageUrl = '';
  List<MessageModel>listMessage;

  @override
  void initState() {
//    focusNode.addListener(onFocusChange);

    MockServer.getMessagesByChatId(widget.chatModel.chatId).then((messages) {
      messageListBloc.add(messages);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw Container();
  }





//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      key: _scaffoldKey,
//      appBar: _appBar(context),
//      backgroundColor: CustomColors.mainBackground,
//      body: WillPopScope(
//        child: Stack(
//          children: <Widget>[
//            Column(
//              children: <Widget>[
//                // List of messages
//                buildListMessage(),
//
//                // Sticker
//                (isShowSticker ? buildSticker() : Container()),
//
//                // Input content
//                buildInput(),
//              ],
//            ),
//
//            // Loading
//            buildLoading()
//          ],
//        ),
//        onWillPop: onBackPress,
//      ),
//    );
//  }
//
//  AppBar _appBar(BuildContext context) {
//    return AppBar(
//      backgroundColor: CustomColors.secondaryBackground,
//      automaticallyImplyLeading: false,
//      actions: <Widget>[
//        Container(
//          width: MediaQuery.of(context).size.width,
//          padding: EdgeInsets.only(left: 20, right: 20),
//          decoration: BoxDecoration(
//              border: Border(
//                  bottom: BorderSide(color: Colors.yellow[800], width: 1)
//              )
//          ),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              _arrowBack(), //TODO set chat name
//              Text(Strings.settings_toolbar, style: TextStyle(color: Colors.white, fontSize: 22),),
//              Container(width: 30, height: 30,)
//            ],
//          ),
//        )
//      ],
//    );
//  }
//
//  Widget _arrowBack() {
//    return GestureDetector(
//      onTap: () {
//        Navigator.of(context).pop();
//      },
//      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
//    );
//  }
//
//  void onSendMessage(String content, int type) {
//    // type: 0 = text, 1 = image, 2 = sticker
//    if (content.trim() != '') {
//      textEditingController.clear();
//
////      var documentReference = Firestore.instance
////          .collection('messages')
////          .document(groupChatId)
////          .collection(groupChatId)
////          .document(DateTime.now().millisecondsSinceEpoch.toString());
//
////      Firestore.instance.runTransaction((transaction) async {
////        await transaction.set(
////          documentReference,
////          {
////            'idFrom': id,
////            'idTo': peerId,
////            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
////            'content': content,
////            'type': type
////          },
////        );
////      });
//      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//    } else {
//      //TODO show message
////      Fluttertoast.showToast(msg: 'Nothing to send');
//    }
//  }
//
//  Widget buildLoading() {
//    return Positioned(
//      child: isLoading
//          ? Container(
//        child: Center(
//          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623))),
//        ),
//        color: Colors.white.withOpacity(0.8),
//      )
//          : Container(),
//    );
//  }
//
//  void onFocusChange() {
//    if (focusNode.hasFocus) {
//      // Hide sticker when keyboard appear
//      setState(() {
//        isShowSticker = false;
//      });
//    }
//  }
//
//  void getSticker() {
//    // Hide keyboard when sticker appear
//    focusNode.unfocus();
//    setState(() {
//      isShowSticker = !isShowSticker;
//    });
//  }
//
//  Future<bool> onBackPress() {
//    if (isShowSticker) {
//      setState(() {
//        isShowSticker = false;
//      });
//    } else {
////      Firestore.instance.collection('users').document(id).updateData({'chattingWith': null});
//      Navigator.pop(context);
//    }
//
//    return Future.value(false);
//  }
//
//  Widget buildSticker() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              FlatButton(
//                onPressed: () => onSendMessage('mimi1', 2),
//                child: new Image.asset(
//                  'images/mimi1.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi2', 2),
//                child: new Image.asset(
//                  'images/mimi2.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi3', 2),
//                child: new Image.asset(
//                  'images/mimi3.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              )
//            ],
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          ),
//          Row(
//            children: <Widget>[
//              FlatButton(
//                onPressed: () => onSendMessage('mimi4', 2),
//                child: new Image.asset(
//                  'images/mimi4.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi5', 2),
//                child: new Image.asset(
//                  'images/mimi5.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi6', 2),
//                child: new Image.asset(
//                  'images/mimi6.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              )
//            ],
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          ),
//          Row(
//            children: <Widget>[
//              FlatButton(
//                onPressed: () => onSendMessage('mimi7', 2),
//                child: new Image.asset(
//                  'images/mimi7.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi8', 2),
//                child: new Image.asset(
//                  'images/mimi8.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              FlatButton(
//                onPressed: () => onSendMessage('mimi9', 2),
//                child: new Image.asset(
//                  'images/mimi9.gif',
//                  width: 50.0,
//                  height: 50.0,
//                  fit: BoxFit.cover,
//                ),
//              )
//            ],
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          )
//        ],
//        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//      ),
//      decoration: new BoxDecoration(
//          border: new Border(top: new BorderSide(color: Colors.green, width: 0.5)), color: Colors.white),
//      padding: EdgeInsets.all(5.0),
//      height: 180.0,
//    );
//  }
//
//  Widget buildListMessage() {
//    // TODO get messages .orderBy('timestamp', descending: true).limit(20).snapshots()
//    return Flexible(
//      child: StreamBuilder(
//        stream: messageListBloc.navStream,
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) {
//            return Center(
//                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[800])));
//          } else {
//            listMessage = snapshot.data.documents;
//            return ListView.builder(
//              padding: EdgeInsets.all(10.0),
//              itemBuilder: (context, index) => buildItem(index, snapshot.data[index]),
//              itemCount: snapshot.data.documents.length,
//              reverse: true,
//              controller: listScrollController,
//            );
//          }
//        },
//      ),
//    );
//  }
//
//  Widget buildInput() {
//    return Container(
//      child: Row(
//        children: <Widget>[
//          // Button send image
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 1.0),
//              child: new IconButton(
//                icon: new Icon(Icons.image),
////                onPressed: getImage,
//                color: Color(0xff203152),
//              ),
//            ),
//            color: Colors.white,
//          ),
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 1.0),
//              child: new IconButton(
//                icon: new Icon(Icons.face),
//                onPressed: getSticker,
//                color: Color(0xff203152),
//              ),
//            ),
//            color: Colors.white,
//          ),
//
//          // Edit text
//          Flexible(
//            child: Container(
//              child: TextField(
//                style: TextStyle(color: Color(0xff203152), fontSize: 15.0),
//                controller: textEditingController,
//                decoration: InputDecoration.collapsed(
//                  hintText: 'Type your message...',
//                  hintStyle: TextStyle(color: Color(0xff203152)),
//                ),
//                focusNode: focusNode,
//              ),
//            ),
//          ),
//
//          // Button send message
//          Material(
//            child: new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 8.0),
//              child: new IconButton(
//                icon: new Icon(Icons.send),
//                onPressed: () => onSendMessage(textEditingController.text, 0),
//                color: Color(0xff203152),
//              ),
//            ),
//            color: Colors.white,
//          ),
//        ],
//      ),
//      width: double.infinity,
//      height: 50.0,
//      decoration: new BoxDecoration(
//          border: new Border(top: new BorderSide(color: Color(0xff203152), width: 0.5)), color: Colors.white),
//    );
//  }
//
//  Widget buildItem(int index, DocumentSnapshot document) {
//    if (document['idFrom'] == id) {
//      // Right (my message)
//      return Row(
//        children: <Widget>[
//          document['type'] == 0
//          // Text
//              ? Container(
//            child: Text(
//              document['content'],
//              style: TextStyle(color: Color(0xff203152)),
//            ),
//            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//            width: 200.0,
//            decoration: BoxDecoration(color: Color(0xffE8E8E8), borderRadius: BorderRadius.circular(8.0)),
//            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//          )
//              : document['type'] == 1
//          // Image
//              ? Container(
//            child: FlatButton(
//              child: Material(
//                child: CachedNetworkImage(
//                  placeholder: (context, url) => Container(
//                    child: CircularProgressIndicator(
//                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
//                    ),
//                    width: 200.0,
//                    height: 200.0,
//                    padding: EdgeInsets.all(70.0),
//                    decoration: BoxDecoration(
//                      color: Color(0xffE8E8E8),
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(8.0),
//                      ),
//                    ),
//                  ),
//                  errorWidget: (context, url, error) => Material(
//                    child: Image.asset(
//                      'images/img_not_available.jpeg',
//                      width: 200.0,
//                      height: 200.0,
//                      fit: BoxFit.cover,
//                    ),
//                    borderRadius: BorderRadius.all(
//                      Radius.circular(8.0),
//                    ),
//                    clipBehavior: Clip.hardEdge,
//                  ),
//                  imageUrl: document['content'],
//                  width: 200.0,
//                  height: 200.0,
//                  fit: BoxFit.cover,
//                ),
//                borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                clipBehavior: Clip.hardEdge,
//              ),
//              onPressed: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
//              },
//              padding: EdgeInsets.all(0),
//            ),
//            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//          )
//          // Sticker
//              : Container(
//            child: new Image.asset(
//              'images/${document['content']}.gif',
//              width: 100.0,
//              height: 100.0,
//              fit: BoxFit.cover,
//            ),
//            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//          ),
//        ],
//        mainAxisAlignment: MainAxisAlignment.end,
//      );
//    } else {
//      // Left (peer message)
//      return Container(
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                isLastMessageLeft(index)
//                    ? Material(
//                  child: CachedNetworkImage(
//                    placeholder: (context, url) => Container(
//                      child: CircularProgressIndicator(
//                        strokeWidth: 1.0,
//                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
//                      ),
//                      width: 35.0,
//                      height: 35.0,
//                      padding: EdgeInsets.all(10.0),
//                    ),
//                    imageUrl: peerAvatar,
//                    width: 35.0,
//                    height: 35.0,
//                    fit: BoxFit.cover,
//                  ),
//                  borderRadius: BorderRadius.all(
//                    Radius.circular(18.0),
//                  ),
//                  clipBehavior: Clip.hardEdge,
//                )
//                    : Container(width: 35.0),
//                document['type'] == 0
//                    ? Container(
//                  child: Text(
//                    document['content'],
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
//                  width: 200.0,
//                  decoration: BoxDecoration(color: Color(0xff203152), borderRadius: BorderRadius.circular(8.0)),
//                  margin: EdgeInsets.only(left: 10.0),
//                )
//                    : document['type'] == 1
//                    ? Container(
//                  child: FlatButton(
//                    child: Material(
//                      child: CachedNetworkImage(
//                        placeholder: (context, url) => Container(
//                          child: CircularProgressIndicator(
//                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)),
//                          ),
//                          width: 200.0,
//                          height: 200.0,
//                          padding: EdgeInsets.all(70.0),
//                          decoration: BoxDecoration(
//                            color: Color(0xffE8E8E8),
//                            borderRadius: BorderRadius.all(
//                              Radius.circular(8.0),
//                            ),
//                          ),
//                        ),
//                        errorWidget: (context, url, error) => Material(
//                          child: Image.asset(
//                            'images/img_not_available.jpeg',
//                            width: 200.0,
//                            height: 200.0,
//                            fit: BoxFit.cover,
//                          ),
//                          borderRadius: BorderRadius.all(
//                            Radius.circular(8.0),
//                          ),
//                          clipBehavior: Clip.hardEdge,
//                        ),
//                        imageUrl: document['content'],
//                        width: 200.0,
//                        height: 200.0,
//                        fit: BoxFit.cover,
//                      ),
//                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                      clipBehavior: Clip.hardEdge,
//                    ),
//                    onPressed: () {
////                        Navigator.push(context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
//                      },
//                    padding: EdgeInsets.all(0),
//                  ),
//                  margin: EdgeInsets.only(left: 10.0),
//                )
//                    : Container(
//                  child: new Image.asset(
//                    'images/${document['content']}.gif',
//                    width: 100.0,
//                    height: 100.0,
//                    fit: BoxFit.cover,
//                  ),
//                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
//                ),
//              ],
//            ),
//
//            // Time
//            isLastMessageLeft(index)
//                ? Container(
//              child: Text(
//                DateFormat('dd MMM kk:mm')
//                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp']))),
//                style: TextStyle(color: Color(0xffaeaeae), fontSize: 12.0, fontStyle: FontStyle.italic),
//              ),
//              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
//            )
//                : Container()
//          ],
//          crossAxisAlignment: CrossAxisAlignment.start,
//        ),
//        margin: EdgeInsets.only(bottom: 10.0),
//      );
//    }
//  }
//
//  bool isLastMessageLeft(int index) {
//    if ((index > 0 && listMessage != null && listMessage[index - 1].userId == widget.yourModel.id) || index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  bool isLastMessageRight(int index) {
//    if ((index > 0 && listMessage != null && listMessage[index - 1].userId != widget.yourModel.id) || index == 0) {
//      return true;
//    } else {
//      return false;
//    }
//  }
}
