import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/services/blocs/message_list_block.dart';
import 'package:travel_date_app/views/screens/mainscreen/main_navigation.dart';
import 'package:travel_date_app/views/screens/registrationflow/agescreen/agescreen.dart';
import 'package:travel_date_app/views/screens/registrationflow/registrationscreen/registration_screen.dart';
import 'package:travel_date_app/views/screens/registrationflow/successverify/success_verify.dart';
import 'package:travel_date_app/views/screens/signin/sign_in.dart';
import 'package:travel_date_app/views/screens/splashscreen/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      blocs: [
        Bloc((i)=> BottomNavBloc()),
        Bloc((i)=> MessageListBloc()),
      ],
      child: MaterialApp(
          title: 'Date App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              canvasColor: Colors.transparent
          ),
          home: MainNavigation(),//Splash(),
          routes: {
            '/signin': (context) => SignInScreen(),
            '/verifyphone': (context) => VerifySuccess(),
            '/setage': (context) => AgeScreen(),
            '/main': (context) => MainNavigation(),
          }
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
// https://www.c-sharpcorner.com/article/pagination-in-flutter-using-firebase-cloud-firestore/