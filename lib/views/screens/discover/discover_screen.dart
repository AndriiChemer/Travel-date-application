import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}
// TODO change array people in grid view
class _DiscoverScreenState extends State<DiscoverScreen> {

  List<PersonModel> people;

  @override
  void initState() {
    super.initState();

    MockServer.getPeoplesForDiscoversScreen().then((List<PersonModel> loadedPeople){
      setState(() {
        people = loadedPeople;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5) + 15;
    final double itemWidth = size.width / 2;

    return Container(
      color: CustomColors.discoverBackgroundScreen,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: (itemWidth / itemHeight),
        padding: const EdgeInsets.all(10),
        children: MockServer.peopleList.map((PersonModel model) {
          return _personItem(model, itemWidth, itemHeight);
        }).toList(),
      ),
    );
  }

  Widget _personItem(PersonModel model, double itemWidth, double itemHeight) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: CustomColors.personItemBackground,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: GestureDetector(
        onTap: personItemClick,
        child: Stack(
          children: <Widget>[
            _buildMainColumnItem(model, itemWidth, itemHeight),
            Row(
              children: <Widget>[
                _goldCircle(),
                _userStatus(model.status)
              ],
            ),
            _blueCircle(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainColumnItem(PersonModel model, double itemWidth, double itemHeight) {
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
            onTap: () {

            },
            child: Container(
              margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              child: Icon(Icons.message, size: 30, color: Colors.yellow[800],),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemImage(PersonModel model, double itemWidth, double itemHeight) {
    return Stack(
      children: <Widget>[
        Container(
          width: itemWidth,
          height: itemWidth - 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(model.imageUrl, ),
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

  Widget _nameCityColumn() {
    return Positioned.fill(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Andrii Chemer, 23", style: TextStyle(color: Colors.white),),
                Text("Wroclaw", style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        )
    );
  }

  personItemClick() {

  }

  onVerifyVideoClick() {

  }
}
