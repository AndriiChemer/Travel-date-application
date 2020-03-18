import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/notification.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/account_watched_notification_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/account_watched_provider.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/user_id_grid_item.dart';

class ViewsProfile extends StatefulWidget {

  final String column;
  final UserModel yourModel;

  ViewsProfile({@required this.yourModel, @required this.column});

  @override
  _ViewsProfileState createState() => _ViewsProfileState();
}

class _ViewsProfileState extends State<ViewsProfile> {

  KissedWatchedNotificationsBloc watchedBloc;

  final ScrollController listScrollController = new ScrollController();

  List<KissWatchNotifModel> peopleWhoWatched = [];

  @override
  void didChangeDependencies() {
    watchedBloc = AccountKissedWatchedProvider.of(context);

    getWhoWatchedMyAccount();
    super.didChangeDependencies();
  }

  getWhoWatchedMyAccount() {
    watchedBloc.getKissedWatchedNotification(widget.yourModel.id, widget.column);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: CustomColors.mainBackground,
        child: _gridListPeople(context),
      ),
    );
  }

  Widget _gridListPeople(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5) + 15;
    final double itemWidth = size.width / 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight)
      ),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: peopleWhoWatched.length,
      itemBuilder: (context, index) => UserIdGridItem(kissWatchNotifModel: peopleWhoWatched[index], itemWidth: itemWidth, itemHeight: itemHeight,)
    );
  }

  //TODO change to static
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

  //TODO change to static
  Widget _arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
    );
  }

  listenGettingPeople() {
    watchedBloc.kissWatchNotification.listen((event) {
      setState(() {
        peopleWhoWatched.addAll(event);
      });
    });
  }


}
