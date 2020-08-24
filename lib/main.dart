import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/services/blocs/message_list_block.dart';
import 'package:travel_date_app/services/blocs/providers/chat_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/providers/general_new_message_bloc_provider.dart';
import 'package:travel_date_app/services/blocs/providers/progress_block_provider.dart';
import 'package:travel_date_app/services/blocs/users_bloc.dart';
import 'package:travel_date_app/views/screens/mainscreen/main_navigation.dart';
import 'package:travel_date_app/views/screens/registrationflow/agescreen/agescreen.dart';
import 'package:travel_date_app/views/screens/registrationflow/successverify/success_verify.dart';
import 'package:travel_date_app/views/screens/signin/setuserdetails/setuserdetail_bloc.dart';
import 'package:travel_date_app/views/screens/signin/setuserdetails/setuserdetails.dart';
import 'package:travel_date_app/views/screens/signin/sign_in.dart';
import 'package:travel_date_app/views/screens/splashscreen/splash_screen.dart';
import 'package:travel_date_app/views/widgets/lifecycle.dart';

import 'services/blocs/providers/users_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addObserver(LifecycleEventHandler());

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      blocs: [
        Bloc((i)=> BottomNavBloc()),
        Bloc((i)=> MessageListBloc()),
        Bloc((i)=> UsersBloc()),
        Bloc((i)=> SetUserDetailBloc()),
      ],
      child: UsersBlocProvider(
        child: ChatBlocProvider(
          child: ImageBlocProvider(
            child: GeneralNewMessageBlocProvider(
                child: MaterialApp(
                    title: 'Date App',
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                        canvasColor: Colors.transparent
                    ),
                    home: Splash(),
                    routes: {
                      '/signin': (context) => SignInScreen(),
                      '/verifyphone': (context) => VerifySuccess(),
                      '/setage': (context) => AgeScreen(),
                      '/mainNavigation': (context) => MainNavigation(),
                      '/setuserdetails': (context) => SetUserDetails(),
                    }
                )
            ),
          ),
        ),
      ),
    );
  }
}

//Firebase CRUD tutorial
//https://www.youtube.com/watch?v=uzkpDEG_4R4

//Swipe animation like tinder
//https://blog.geekyants.com/tinder-swipe-in-flutter-7e4fc56021bc

//Verification mobile code
//https://medium.com/@cavdy/flutter-tutorial-phone-verification-and-authentication-b8ea5ddea18d

//Scroll pagination
//https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/

//Chat
//https://www.c-sharpcorner.com/article/chat-app-in-flutter-using-google-firebase/

//Firestore pagination
//https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/


//Bloc pattern firestore
//https://medium.com/flutterpub/when-firebase-meets-bloc-pattern-fb5c405597e0
//https://github.com/SAGARSURI/Goals/blob/master/lib/src/ui/widgets/people_goals_list.dart

// Save image to Firestorage
// https://www.youtube.com/watch?v=Ze5A_sRL6ww
// https://www.c-sharpcorner.com/article/upload-image-file-to-firebase-storage-using-flutter/

//Chat
// https://www.davidanaya.io/flutter/architect-flutter.html
// https://stackoverflow.com/questions/54021134/streambuilder-firestore-pagination