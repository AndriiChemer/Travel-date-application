import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/screens/viewedprofilescreen/who_view_profile.dart';
import 'package:travel_date_app/views/widgets/bottom_nav_menu.dart';

import 'account/account_screen.dart';
import 'chats/chatsscreen.dart';
import 'discover/discover_screen.dart';

class MainNavigation extends StatefulWidget {

  final UserModel userModel;

  MainNavigation({this.userModel});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _viewCounterNotification = MockServer.peopleList.length;
  int _kissCounterNotification = 3;

  List<Widget> navigationScreens;

  @override
  void initState() {
    super.initState();
    navigationScreens = [
      DiscoverScreen(),
      Container(child: Center(child: Text("2", style: TextStyle(color: Colors.white)),),),
      ChatListScreen(yourAccount: widget.userModel),
      AccountScreen(user: widget.userModel)
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("ANDRII MainNavigation build");
    BottomNavBloc bottomNavBloc = BlocProvider.getBloc<BottomNavBloc>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppBar(context),
      body: StreamBuilder(
        stream: bottomNavBloc.navStream,
        builder: (context, snapshot) {
          return snapshot.data != null && navigationScreens.length > 0 ?
            navigationScreens[snapshot.data] : Center(child: Text("Data snapshot == null"),);
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(),
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
            _viewCounterNotification > 0 ? Container(
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
                      _viewCounterNotification.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _kissIcon() {
    return GestureDetector(
      onTap: () {
        showFeatureNotImplementedYet();
      },
      child: Container(
        child: Stack(
          children: [
            SvgPicture.asset("assets/images/icons/lips_icon.svg", height: 35, color: Colors.yellow[800],),
            _kissCounterNotification > 0 ? Container(
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
                      _kissCounterNotification.toString(),
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ) : Container(),
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewsProfile(people: MockServer.peopleList,)));
  }
}
