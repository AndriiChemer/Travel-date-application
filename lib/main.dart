import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_date_app/services/blocs/bottom_nav_bloc.dart';
import 'package:travel_date_app/views/screens/mainscreen/main_navigation.dart';
import 'package:travel_date_app/views/screens/registrationflow/agescreen/agescreen.dart';
import 'package:travel_date_app/views/screens/registrationflow/registrationscreen/registration_screen.dart';
import 'package:travel_date_app/views/screens/registrationflow/successverify/success_verify.dart';
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
      ],
      child: MaterialApp(
          title: 'Date App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              canvasColor: Colors.transparent
          ),
          home: MainNavigation(),//Splash(),
          routes: {
            '/singup': (context) => RegistrationScreen(),
            '/verifyphone': (context) => VerifySuccess(),
            '/setage': (context) => AgeScreen(),
          }
      ),
    );
  }
}


//Firebase CRUD tutorial
//https://www.youtube.com/watch?v=uzkpDEG_4R4

//Swipe animation like tinder
//https://blog.geekyants.com/tinder-swipe-in-flutter-7e4fc56021bc