import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/mock_server.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/screens/userdetail/user_details.dart';
import 'package:travel_date_app/views/widgets/user_grid_item.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}
// TODO change array people in grid view
class _DiscoverScreenState extends State<DiscoverScreen> {

  bool isLoading = true;
  List<UserModel> people = [];


  @override
  void initState() {
    super.initState();

    MockServer.getPeoplesForDiscoversScreen().then((List<UserModel> loadedPeople) {
      setState(() {
        people = loadedPeople;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5) + 15;
    final double itemWidth = size.width / 2;

    return Container(
      color: CustomColors.mainBackground,
      child: isLoading ? _loading() : _mainContent(itemWidth, itemHeight),
    );
  }

  Widget _mainContent(double itemWidth, double itemHeight) {
    return people == null || people.length == 0 ? Container() : GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (itemWidth / itemHeight),
      padding: const EdgeInsets.all(10),
      children: people.map((UserModel model) {
        return UserGridItem(model: model, itemWidth: itemWidth, itemHeight: itemHeight,);
      }).toList(),
    );
  }

  Widget _loading() {
    return Center(
      child: SpinKitFadingCube(
        color: Colors.yellow[800],
        size: 80,
      ),
    );
  }
}
