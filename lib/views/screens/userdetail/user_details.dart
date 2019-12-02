import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';

/*
* Features:
* 1. Open full image.
* 2. Slide Image
*
*
* */
class UserDetails extends StatefulWidget {
  final UserModel user;

  UserDetails({@required this.user});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(context),
      backgroundColor: CustomColors.mainBackground,
      body: ListView(
        children: <Widget>[
          _userImage(),
          _userInformation(),
          _userDescription(),
          _emptyRow(context, 30),
          _sendChampagne(),
          _emptyRow(context, 3),
          _sendMessage(),
          _emptyRow(context, 3),
          _reportUser(),
        ],
      ),
    );
  }

  Widget _sendChampagne() {
    return _buildButton(SvgPicture.asset("assets/images/icons/lips_icon.svg", height: 40, color: Colors.yellow[800],), Strings.send_champagne, onSendChampagneClick);
  }

  Widget _sendMessage() {
    return _buildButton(Icon(Icons.message, size: 40, color: Colors.yellow[800],), Strings.send_message, onSendMessageClick);
  }

  Widget _reportUser() {
    return _buildButton(Icon(Icons.report_problem, size: 40, color: Colors.yellow[800],), Strings.report_user, onReportUserClick);
  }

  Widget _buildButton(Widget icon, String buttonText, GestureTapCallback callback) {
     return GestureDetector(
       onTap: callback,
       child: Container(
         color: CustomColors.personItemBackground,
         padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
         child: Row(
           children: <Widget>[
             icon,
             SizedBox(width: 10,),
             Text(buttonText, style: TextStyle(color: Colors.yellow[800], fontSize: 20),)
           ],
         ),
       ),
     );

  }

  Widget _emptyRow(BuildContext context, double height) {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _userDescription() {
    return widget.user.description != null ? Container(
      color: CustomColors.personItemBackground,
      padding: EdgeInsets.all(20),
      child: Text(widget.user.description != null ? widget.user.description : "", style: TextStyle(color: Colors.white),),
    ) : Container();
  }

  Widget _userImage() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.user.imageUrl),
              fit: BoxFit.cover,
            )
        ),
      ),
    );
  }
  
  Widget _userInformation() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _userNameAgeRow(),
          SizedBox(height: 10,),
          _cityInfo()
        ],
      ),
    );
  }

  Widget _cityInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.user.city, style: TextStyle(color: Colors.grey, fontSize: 15),),
        _verificationVideoRow()
      ],
    );
  }

  Widget _userNameAgeRow() {
    return Row(
      children: <Widget>[
        Text("Andrii Chemer, 23", style: TextStyle(color: Colors.white, fontSize: 23),),
        _goldCircle(),
        _blueCircle()
      ],
    );
  }

  Widget _goldCircle() {
    return Container(
      width: 18,
      height: 18,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          shape: BoxShape.circle
      ),
    );
  }

  Widget _blueCircle() {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 18,
        height: 18,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.blue[800],
            shape: BoxShape.circle
        ),
        child: Center(
          child: Icon(Icons.done, color: Colors.white, size: 15,),
        ),

      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.toolbarBackground,
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
              _arrowBack(),
              Image.asset("assets/images/logo_big.png",),
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

  Widget _verificationVideoRow() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Icon(Icons.play_circle_outline, color: Colors.yellow[800], size: 15,),
            ),
            Text("Verification Video", style: TextStyle(color: Colors.yellow[800], fontSize: 15),),
          ],
        ),
      ),
    );
  }

  onSendChampagneClick() {
    showFeatureNotImplementedYet();
  }

  onSendMessageClick() {
    showFeatureNotImplementedYet();
  }

  onReportUserClick() {
    // TODO fix android (create dialog for ios)
    var dialog = CupertinoAlertDialog(
      title: Text("Report", style: TextStyle(color: Colors.yellow[800], fontSize: 25),),
      content: Text("Are you sure to report this user?", style: TextStyle(fontSize: 18),),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {

          },
          isDefaultAction: true,
          child: Text("Yes"),
        ),
        CupertinoDialogAction(
          onPressed: () {

          },
          child: Text("No"),
        ),
      ],
    );

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  void showFeatureNotImplementedYet() {
    final snackBar = SnackBar(
      content: Text("This feature not implemented yet!", style: TextStyle(color: Colors.white, fontSize: 15),),
      duration: Duration(milliseconds: 550),
      backgroundColor: Colors.red[900],

    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
