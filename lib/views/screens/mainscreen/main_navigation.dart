import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/account_kissed_watched_notification_bloc.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/users_provider.dart';
import 'package:travel_date_app/services/blocs/users_bloc.dart';
import 'package:travel_date_app/services/repository/columns.dart';
import 'package:travel_date_app/services/repository/new_messages_repository.dart';
import 'package:travel_date_app/services/repository/user_repository.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/screens/kisswatchprofilescreen/who_kiss_watch_profile.dart';
import 'package:travel_date_app/views/widgets/bottom_nav_menu.dart';

import 'account/account_screen.dart';
import 'chats/chat_list_screen.dart';
import 'discover/discover_screen.dart';

class MainNavigation extends StatefulWidget {

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UsersBloc usersByLocationBloc;
  UserModel userModel;

  List<Widget> navigationScreens;
  UserRepository _userRepository = UserRepository();
  KissedWatchedBloc kissedWatchedBloc = KissedWatchedBloc();
  NewMessagesRepository newMessageRepository = NewMessagesRepository();

  @override
  void didChangeDependencies() {
    print('didChangeDependencies start');
    usersByLocationBloc = UsersBlocProvider.of(context);

    if(userModel == null) {
      userModel = ModalRoute.of(context).settings.arguments as UserModel;
    }
    usersByLocationBloc.getUsersByLocation(userModel.city);
    usersByLocationBloc.getChats(userModel.id);
    usersByLocationBloc.isEmptyUsersByLocation.listen((onValue) {
      usersByLocationBloc.getUsers();
    });

    navigationScreens = [
      DiscoverScreen(),
      Container(child: Center(child: Text("2", style: TextStyle(color: Colors.white)),),),
      ChatListScreen(yourAccount: userModel),
      AccountScreen(user: userModel)
    ];

    print('didChangeDependencies end');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build start');
    _userRepository.handleOnlineState(userModel.id, true);
    BottomNavBloc bottomNavBloc = BlocProvider.getBloc<BottomNavBloc>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(context),
      body: StreamBuilder(
        stream: bottomNavBloc.navStream,
        builder: (context, snapshot) {
          print('stream start');
          return snapshot.data != null && navigationScreens.length > 0 ?
            navigationScreens[snapshot.data] : Center(child: Text("Data snapshot == null"),);
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(userModel: userModel),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.toolbarBackground,
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(right: 20, left: 20),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.yellow[800], width: 1)
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _viewsIcon(),
              _getLogoImage(),
              _kissIcon(),
            ],
          ),
        )
      ],
    );
  }

  Widget _viewsIcon() {
    return GestureDetector(
      onTap: onViewedIconClick,
      child: Container(
        child: Stack(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.yellow[800], size: 35,),
            StreamBuilder(
              stream: kissedWatchedBloc.getNewAccountWatchedCounter(userModel.id),
              builder: (context, snapshot) {

                if(!snapshot.hasData) {
                  return Container();
                }

                var watchCount = snapshot.data.documents.length;

                return watchCount > 0 ? Container(
                  width: 40,
                  height: 30,
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow[800],
                        border: Border.all(color: Colors.black, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: Text(
                          watchCount.toString(),
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ) : Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _kissIcon() {
    return GestureDetector(
      onTap: onKissedIconClick,
      child: Container(
        child: Stack(
          children: [
            SvgPicture.asset("assets/images/icons/lips_icon.svg", height: 35, color: Colors.yellow[800],),
            StreamBuilder(
                stream: kissedWatchedBloc.getNewAccountKissedCounter(userModel.id),
                builder: (context, snapshot) {

                  print('snapshot.hasData = ${snapshot.hasData}');
                  if (!snapshot.hasData) {
                    print("Does not has Data");
                    return Container();
                  }
                  print("Has Data");

                  var kissCount = snapshot.data.documents.length;
                  print('kissCount = $kissCount');

                  return kissCount > 0 ? Container(
                    width: 40,
                    height: 30,
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellow[800],
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text(
                            kissCount.toString(),
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ) : Container();
                }
            )
          ],
        ),
      ),
    );
  }

  Widget _getLogoImage() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/signin');
      },
      child: Image.asset("assets/images/logo_big.png",),
    );
  }

  void showFeatureNotImplementedYet() {
    final snackBar = SnackBar(
      content: Text("This feature not implemented yet!", style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  onViewedIconClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => KissedWatchedProfile(column: Columns.WATCHED_COLUMN, yourModel: userModel,)));
  }

  onKissedIconClick() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => KissedWatchedProfile(column: Columns.KISSED_COLUMN, yourModel: userModel,)));
  }

}
