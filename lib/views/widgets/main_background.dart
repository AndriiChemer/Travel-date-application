import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainBackground extends StatefulWidget {

  Widget child;

  MainBackground({@required this.child});

  @override
  _MainBackgroundState createState() => _MainBackgroundState();
}

class _MainBackgroundState extends State<MainBackground> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/main_background.jpg"),
            fit: BoxFit.cover,
          )
      ),
      child: Container(
          color: Colors.black.withOpacity(0.55),
          child: widget.child
      ),
    );
  }
}
