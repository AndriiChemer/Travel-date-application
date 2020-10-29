import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/chat.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/chat_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/chat_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/providers/users_provider.dart';
import 'package:travel_date_app/services/blocs/users_bloc.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';
import 'package:travel_date_app/views/widgets/chat_widget.dart';

class ChatListScreen extends StatefulWidget {

 final UserModel yourAccount;

 ChatListScreen({@required this.yourAccount});

 @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var searchTextFieldController = TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isLoading = true;
  ChatBloc _chatBloc;
  UsersBloc _usersBloc;
  List<ChatModel> chatModels = [];

  @override
  void didChangeDependencies() {
    _chatBloc = ChatBlocProvider.of(context);
    _usersBloc = UsersBlocProvider.of(context);

    addScrollListener();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.mainBackground,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[

          ];
        },
        body: Column(
          children: [
            _searchTextField(),
            _divider(context),
            _usersInChat(),
            _chatList(),
            _loading(),
          ],
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return StreamBuilder(
      initialData: true,
      stream: _chatBloc.emptyContent,
      builder: (context, snapshot) {
        return snapshot.data ? Container() : Container(
          margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
          child: TextFormField(
            autofocus: false,
            controller: searchTextFieldController,
            style: TextStyle(fontSize: 15.0, color: Colors.grey[900]),
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: Strings.search,
                prefixIcon: Icon(Icons.search, color: Colors.grey[800],),
                contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 12.0),
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
    );
  }

  Widget _usersInChat() {
    return StreamBuilder(
        initialData: true,
        stream: _chatBloc.emptyContent,
        builder: (context, snapshot) {
          return snapshot.data ? Container() : Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("Matches", style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: 70,
                      child: ListView.builder(
                          itemCount: chatModels.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {

                            if(chatModels.isEmpty) {
                              return Container();
                            }

                            String userID = chatModels[index].ids
                                .where((model) => model.userId != widget.yourAccount.id)
                                .toList()
                                .first
                                .userId;

                            return _circleImage(userID);
                          }
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
    );
  }

  Widget _chatList() {
    return Flexible(
      flex: 1,
      child: StreamBuilder(
        stream: _chatBloc.getStreamChatListByUserId(widget.yourAccount.id),
        initialData: null,
        builder: (context, snapshot) {
          _chatBloc.isShowProgress(false);

          if(!snapshot.hasData) {

            return _showEmptyChats();
          } else {

            List<ChatModel> chats = _chatBloc.chatsConverter(snapshot.data.documents);

            if(chats.length > 0) {
              _chatBloc.isShowProgress(false);
              _chatBloc.showEmptyContent(false);
              addToMainChatList(chats, true);
            } else {
              return _showEmptyChats();
            }

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => ChatItem(chatModels[index], widget.yourAccount),
              itemCount: chatModels.length,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget _showEmptyChats() {
    return Center(
      child: Container(
        child: Text('There are no any chats :(', style: TextStyle(fontSize: 24, color: Colors.yellow[800]),),
      ),
    );
  }

  Widget _loading() {

    return StreamBuilder(
        initialData: true,
        stream: _chatBloc.showProgress,
        builder: (context, snapshot) {
          return snapshot.data ? Expanded(child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: SpinKitFadingCube(
                color: Colors.yellow[800],
                size: 30,
              ),
            ),
          )) : Container();
        }
    );
  }

  @override
  void dispose() {
    searchTextFieldController.dispose();
    super.dispose();
  }

  Widget _circleImage(String userId) {
    return StreamBuilder(
      stream: _usersBloc.getUserByIdStream(userId),
      builder: (context, snapshot) {

        if(!snapshot.hasData) {
          return Container();
        }

        UserModel user = _usersBloc.usersConverter(widget.yourAccount.id, snapshot.data.documents).first;

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: user,)));
          },

          child: Container(
            margin: EdgeInsets.only(top: 5, bottom: 10, right: 20),
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
      },
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
    return StreamBuilder(
        initialData: true,
        stream: _chatBloc.emptyContent,
        builder: (context, snapshot) {
          return snapshot.data ? Container() : Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey,
          );
        }
    );
  }

  void addToMainChatList(List<ChatModel> chats, bool isFromStream) {
    List<ChatModel> sorted = [];
    List<int> indexesForRemoving = [];

    int index = 0;
    chats.forEach((chat) {

      if(contains(chatModels, chat)) {

        var existingChat = chatModels[index];

        if(!equals(chat, existingChat)) {
          print("\n updated chat${chat.lastMessage}\nold chat:${existingChat.lastMessage} \n");
          sorted.add(chat);
          indexesForRemoving.add(index);
        }

      } else {
        sorted.add(chat);
      }

      index++;
    });

    if(isFromStream) {

      indexesForRemoving.forEach((element) {
        chatModels.removeAt(element);
      });

      chatModels.insertAll(0, sorted);

    } else {
      chatModels.addAll(sorted);
    }
  }

  bool equals(ChatModel newChat, ChatModel existingChat) {

    if(newChat.lastMessageAt == existingChat.lastMessageAt &&
        newChat.lastMessage == existingChat.lastMessage &&
        newChat.adminId == newChat.adminId) {
      return true;
    }

    return false;
  }

  bool contains(List<ChatModel> list, ChatModel chat) {
    String groupChatId = chat.groupChatId;

    for(ChatModel itemChat in list) {
      if(itemChat.groupChatId == groupChatId) {
        return true;
      }
    }

    return false;
  }

  void addScrollListener() {
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      print("maxScroll = $maxScroll");
      print("currentScroll = $currentScroll");
      print("delta = $delta");
      if(maxScroll - currentScroll <= delta) {
//        _messageBloc.getMessages(widget.groupCharId);
      }
    });
  }
}
