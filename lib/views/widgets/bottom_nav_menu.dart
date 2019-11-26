import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/utils/colors.dart';

class CustomBottomNavigation extends StatefulWidget {
  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {

  int selectedIndex = 0;
  List<NavigationItem> listNavItem = [
    NavigationItem(Icon(Icons.person_pin_circle), "Discover"),
    NavigationItem(Icon(Icons.search), "Search"),
    NavigationItem(Icon(Icons.message), "Message"),
    NavigationItem(Icon(Icons.account_circle), "Profile"),
  ];

  final BottomNavBloc bottomNavBloc = BlocProvider.getBloc<BottomNavBloc>();

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
      child: Row(
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
            child: buildItems(item, selectedIndex == itemIndex),
          );
        }).toList(),
      ),
    );
  }

  Widget buildItems(NavigationItem item, bool isSelected) {
    String name = item.text;

    return Container(
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