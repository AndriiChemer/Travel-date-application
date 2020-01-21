import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/message_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/message_bloc_provider.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';
import 'package:travel_date_app/views/widgets/new_chat_widget.dart';

class UserGridItem extends StatefulWidget {

  final UserModel model;
  final double itemWidth;
  final double itemHeight;


  UserGridItem({@required this.model, @required this.itemWidth, @required this.itemHeight, });

  @override
  _UserGridItemState createState() => _UserGridItemState();
}

class _UserGridItemState extends State<UserGridItem> {

  final _userPreferences = UserPreferences();
  MessageBloc _messageBloc;

  @override
  void didChangeDependencies() {
    _messageBloc = MessageBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: CustomColors.personItemBackground,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetails(user: widget.model,)));
          },
          child: Stack(
            children: <Widget>[
              _buildMainColumnItem(widget.model, widget.itemWidth, widget.itemHeight),
              Row(
                children: <Widget>[
                  _goldCircle(),
                  _userStatus(widget.model.status)
                ],
              ),
              _blueCircle(),
            ],
          ),
        )
    );
  }

  Widget _buildMainColumnItem(UserModel model, double itemWidth, double itemHeight) {
    return Column(
      children: <Widget>[
        _itemImage(model, itemWidth, itemHeight),
        _verificationVideoRow(),
        _bottomButtons()
      ],
    );
  }

  Widget _bottomButtons() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {

            },
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 5, bottom: 5),
              child: SvgPicture.asset("assets/images/icons/lips_icon.svg", height: 30, color: Colors.yellow[800],),
            ),
          ),
          GestureDetector(
            onTap: onMessageButtonClick,
            child: Container(
              margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              child: Icon(Icons.message, size: 30, color: Colors.yellow[800],),
            ),
          )
        ],
      ),
    );
  }

  Widget _verificationVideoRow() {
    return GestureDetector(
      onTap: onVerifyVideoClick,
      child: Container(
        padding: EdgeInsets.all(5),
        color: Colors.yellow[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(Icons.play_circle_outline, color: Colors.grey[800], size: 15,),
            ),
            Text("Verification Video", style: TextStyle(color: Colors.grey[800], fontSize: 13),),
          ],
        ),
      ),
    );
  }

  Widget _goldCircle() {
    return Container(
      width: 12,
      height: 12,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          shape: BoxShape.circle
      ),
    );
  }

  Widget _userStatus(String status) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      padding: EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.yellow[800].withOpacity(0.7),
      ),
      child: Text('$status', style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.w500),),
    );
  }

  Widget _itemImage(UserModel model, double itemWidth, double itemHeight) {
    return Stack(
      children: <Widget>[
        Container(
          width: itemWidth,
          height: itemWidth - 25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              image: DecorationImage(
                image: model.imageUrl == '' ? AssetImage(model.getEmptyPhoto()) : NetworkImage(model.imageUrl, ),
                fit: BoxFit.cover,
              )
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter, // 10% of the width, so there are ten blinds.
                colors: [Colors.white.withOpacity(0.15), Colors.black, ], // whitish to gray
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
          ),
        ),
        _nameCityColumn(),
      ],
    );
  }

  Widget _nameCityColumn() {
    String name = widget.model.name;
    String age = widget.model.calculateAge();
    String city = widget.model.city;

    return Positioned.fill(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("$name, $age", style: TextStyle(color: Colors.white),),
                Text(city, style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        )
    );
  }

  Widget _blueCircle() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 12,
        height: 12,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue[800],
            shape: BoxShape.circle
        ),
        child: Center(
          child: Icon(Icons.done, color: Colors.white, size: 10,),
        ),

      ),
    );
  }

  onMessageButtonClick() async {
    _userPreferences.getUser().then((currentUser) {
      String groupCharId = buildGroupChatId(currentUser.id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewChatScreen(yourModel: currentUser, anotherModel: widget.model, groupCharId: groupCharId)));
    }).catchError((onError) {
      //TODO task show toast "You can not write message"
    });

  }

  onVerifyVideoClick() {

  }

  String buildGroupChatId(String currentId) {
    String groupChatId;
    if (currentId.hashCode <= widget.model.id.hashCode) {
      groupChatId = '$currentId-${widget.model.id}';
    } else {
      groupChatId = '${widget.model.id}-$currentId';
    }

    return groupChatId;
  }
}
