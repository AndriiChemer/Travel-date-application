import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/providers/users_by_location_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/users_by_location_bloc.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/views/widgets/user_grid_item.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  UsersByLocationBloc usersByLocationBloc;
  UserPreferences _userPreferences = UserPreferences();

  bool isEmptyUsersByLocation = false;
  UserModel ownModel;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getUserPreferences();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    usersByLocationBloc = UsersByLocationBlocProvider.of(context);
    addScrollListener();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5) + 15;
    final double itemWidth = size.width / 2;

    return Container(
      width: size.width,
      height: size.height,
      color: CustomColors.mainBackground,
      child: _buildGrid(itemWidth, itemHeight)
    );
  }
  
  Widget _buildGrid(double itemWidth, double itemHeight) {
    return StreamBuilder(
      initialData: [],
      stream: usersByLocationBloc.users,
      builder: (context, snapshot) {

        return snapshot.hasData ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight)
          ),
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          itemCount: snapshot.data.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return UserGridItem(model: snapshot.data[index], itemWidth: itemWidth, itemHeight: itemHeight);
          },
        ) : Container();
      },
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

  addScrollListener() {
      _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.2;
      if(maxScroll - currentScroll <= delta) {
        if(!isEmptyUsersByLocation) {
          usersByLocationBloc.getUsersByLocation(ownModel.city);
        } else {
          usersByLocationBloc.getUsers();
        }
      }
    });
  }

  void getUserPreferences() {
    _userPreferences.getUser().then((user){
      setState(() {
        ownModel = user;
      });
    });
  }
}
