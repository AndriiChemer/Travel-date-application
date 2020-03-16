import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/services/blocs/general_new_message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/general_new_message_bloc_provider.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';

class CustomBottomNavigation extends StatefulWidget {

  final UserModel userModel;

  const CustomBottomNavigation({Key key, this.userModel}) : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  int selectedIndex = 0;
  List<NavigationItem> listNavItem = [
    NavigationItem(Icon(Icons.person_pin_circle), Strings.discover_nav),
    NavigationItem(Icon(Icons.search), Strings.search_nav),
    NavigationItem(Icon(Icons.message), Strings.message_nav),
    NavigationItem(Icon(Icons.account_circle), Strings.profile_nav),
  ];

  final BottomNavBloc bottomNavBloc = BlocProvider.getBloc<BottomNavBloc>();

  GeneralNewMessageBloc _generalNewMessageBloc;

  @override
  void didChangeDependencies() {
    _generalNewMessageBloc = GeneralNewMessageBlocProvider.of(context);
    super.didChangeDependencies();
  }

//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: 57,
//      width: MediaQuery.of(context).size.width,
//      padding: EdgeInsets.only(right: 15, left: 15, top: 4, bottom: 4),
//      decoration: BoxDecoration(
//        color: CustomColors.bottomBackground,
//        boxShadow: [
//          BoxShadow(
//              color: Colors.yellow[800],
//              blurRadius: 5
//          )
//        ],
//      ),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: listNavItem.map((item) {
//          var itemIndex = listNavItem.indexOf(item);
//          return GestureDetector(
//            onTap: () {
//              bottomNavBloc.setNavIndexPage(itemIndex);
//              setState((){
//                selectedIndex = itemIndex;
//              });
//            },
//            child: buildItems(item, selectedIndex == itemIndex),
//          );
//        }).toList(),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15, left: 15, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: CustomColors.bottomBackground,
        boxShadow: [
          BoxShadow(
              color: Colors.yellow[800],
              blurRadius: 5
          )
        ],
      ),
      child: StreamBuilder(
        stream: _generalNewMessageBloc.getNewMessageCount(widget.userModel.id),
        initialData: "0",
        builder: (context, snapshot) {

          int newMessages = snapshot.data["counter"] ?? 0;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: listNavItem.map((item) {
              var itemIndex = listNavItem.indexOf(item);
              return GestureDetector(
                onTap: () {
                  bottomNavBloc.setNavIndexPage(itemIndex);
                  setState((){
                    selectedIndex = itemIndex;
                  });
                },
                child: buildItems(item, newMessages, selectedIndex == itemIndex),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildItems(NavigationItem item, int newMessageCount, bool isSelected) {
    String name = item.text;

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(2),
          child: Column(
            children: <Widget>[
              IconTheme(
                  data: IconThemeData(size: 27, color: getItemColor(isSelected)),
                  child: item.icon
              ),
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Text('$name', style: TextStyle(color: getItemColor(isSelected)),),
              )
            ],
          ),
        ),
        newMessageCount == 0 ? Container() : _notification(newMessageCount, item)
      ],
    );
  }

  Widget _notification(int notificationCount, NavigationItem item) {
    int index = listNavItem.indexOf(item);
    return Positioned(
      right: 10,
      child: index == 2 ? Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        child: Text(
          '$notificationCount',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ) : Container(),
    );
  }

  Color getItemColor(bool isSelected) {
    return isSelected ? Colors.yellow[800] : Colors.yellow[600];
  }
}

class NavigationItem {
  final Icon icon;
  final String text;

  NavigationItem(this.icon, this.text);
}