import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_date_app/views/screens/registrationscreen/registration_screen.dart';
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

      ],
      child: MaterialApp(
          title: 'Date App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              canvasColor: Colors.transparent
          ),
          home: Splash(),
          routes: {
            '/singup': (context) => RegistrationScreen(),
          }
      ),
    );
  }
}
