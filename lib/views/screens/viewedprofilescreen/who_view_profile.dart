import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/user_grid_item.dart';

class ViewsProfile extends StatefulWidget {

  final List<UserModel> people;


  ViewsProfile({@required this.people});

  @override
  _ViewsProfileState createState() => _ViewsProfileState();
}

class _ViewsProfileState extends State<ViewsProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Container(
        color: CustomColors.mainBackground,
        child: _gridListPeople(context),
      ),
    );
  }

  Widget _gridListPeople(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5) + 15;
    final double itemWidth = size.width / 2;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      padding: const EdgeInsets.all(10),
      children: widget.people.map((UserModel model) {
        return UserGridItem(model: model, itemWidth: itemWidth, itemHeight: itemHeight,);
      }).toList(),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.toolbarBackground,
      automaticallyImplyLeading: false,
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
              _arrowBack(),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(Strings.view_profile_toolbar_title, style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              )
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
}
