import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/notification.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/account_kissed_watched_notification_bloc.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/widgets/app_bars.dart';
import 'package:travel_date_app/views/widgets/user_id_grid_item.dart';

class KissedWatchedProfile extends StatefulWidget {

  final String column;
  final UserModel yourModel;

  KissedWatchedProfile({@required this.yourModel, @required this.column});

  @override
  _KissedWatchedProfileState createState() => _KissedWatchedProfileState();
}

class _KissedWatchedProfileState extends State<KissedWatchedProfile> {

  KissedWatchedBloc kissWatchedNotificBloc = KissedWatchedBloc();
  final ScrollController listScrollController = new ScrollController();

  List<KissWatchNotifModel> peopleWhoKissWatched = [];

  @override
  void initState() {
    listenGettingPeople();
    getWhoWatchedMyAccount();

    super.initState();
  }

  getWhoWatchedMyAccount() {
    kissWatchedNotificBloc.getKissedWatchedNotification(widget.yourModel.id, widget.column);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Strings.view_profile_toolbar_title),
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
      controller: listScrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight)
      ),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: peopleWhoKissWatched.length,
      itemBuilder: (context, index) => UserIdGridItem(kissWatchNotifModel: peopleWhoKissWatched[index], itemWidth: itemWidth, itemHeight: itemHeight,)
    );
  }

  listenGettingPeople() {
    kissWatchedNotificBloc.kissWatchNotification.listen((event) {
      addNotificationToList(event);
    });
    kissWatchedNotificBloc.resetStream();
  }

  addNotificationToList(List<KissWatchNotifModel> list) {
    List<KissWatchNotifModel> sorted = [];

    list.forEach((model) {
      if(!contains(peopleWhoKissWatched, model)) {
        sorted.add(model);
      }
    });

    if(sorted.length > 0) {
      setState(() {
        peopleWhoKissWatched.addAll(sorted);
      });

      updateVisibleItems();
      updateDuringScroll();
    }

  }

  void updateVisibleItems() {
    int firstVisibleItemIndex = getFirstVisibleItemIndex();
    int lastVisibleItemIndex = getLastVisibleItemIndex();
    int step = firstVisibleItemIndex;

    print("===================================================================");
    print("firstVisibleItemIndex = $firstVisibleItemIndex");
    print("lastVisibleItemIndex = $lastVisibleItemIndex");

    if(!peopleWhoKissWatched[firstVisibleItemIndex].isWatched) {
      print("peopleWhoKissWatched[firstVisibleItemIndex].isWatched = ${peopleWhoKissWatched[firstVisibleItemIndex].isWatched}");

      while(lastVisibleItemIndex > step) {
        if(!peopleWhoKissWatched[step].isWatched) {
          print("when step is $step then true");
          peopleWhoKissWatched[step].isWatched = true;
          kissWatchedNotificBloc.updateNotification(widget.column, peopleWhoKissWatched[step]);
        }

        step++;
      }

      kissWatchedNotificBloc.setNewNotificationIndex(step);
    }
  }

  void updateDuringScroll() {
    Future.delayed(Duration(milliseconds: 700), () {
      listScrollController.addListener(() {
        int lastVisibleItem = getLastVisibleItemIndex();

        if(lastVisibleItem > -1) {

          if(lastVisibleItem == 0 && peopleWhoKissWatched[lastVisibleItem].isWatched) {
            kissWatchedNotificBloc.setNewNotificationIndex(-1);
          } else {
            if(!peopleWhoKissWatched[lastVisibleItem].isWatched) {
              peopleWhoKissWatched[lastVisibleItem].isWatched = true;
              kissWatchedNotificBloc.updateNotification(widget.column, peopleWhoKissWatched[lastVisibleItem]);
            }
          }

        } else {
          kissWatchedNotificBloc.setNewNotificationIndex(-1);
        }
      });
    });
  }

  bool contains(List<KissWatchNotifModel> list, KissWatchNotifModel model) {

    for(KissWatchNotifModel itemModel in list) {
      if(itemModel.fromUserId == model.fromUserId) {
        return true;
      }
    }
    return false;
  }

  int getLastVisibleItemIndex() {
    double scrollOffset = listScrollController.position.pixels;
    double viewportHeight = listScrollController.position.viewportDimension;
    double maxScrollExtent = listScrollController.position.maxScrollExtent;
    double minScrollExtent = listScrollController.position.minScrollExtent;
    double scrollRangeMin = maxScrollExtent - minScrollExtent;

    return ((scrollOffset + MediaQuery.of(context).size.height) / (scrollRangeMin + viewportHeight) * peopleWhoKissWatched.length).floor();
  }

  int getFirstVisibleItemIndex() {
    double scrollOffset = listScrollController.position.pixels;
    double viewportHeight = listScrollController.position.viewportDimension;
    double maxScrollExtent = listScrollController.position.maxScrollExtent;
    double minScrollExtent = listScrollController.position.minScrollExtent;
    double scrollRange = maxScrollExtent - minScrollExtent;
    return (scrollOffset / (scrollRange + viewportHeight) * peopleWhoKissWatched.length).floor();
  }

  @override
  void dispose() {
    kissWatchedNotificBloc.dispose();
    super.dispose();
  }
}
