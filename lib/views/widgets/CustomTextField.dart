import 'package:flutter/material.dart';
import 'package:travel_date_app/utils/colors.dart';

class CustomTextField extends StatefulWidget {

  final String name;
  final TextEditingController controller;
  final IconData iconData;

  const CustomTextField({this.name, this.controller, this.iconData});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.name, style: TextStyle(color: Colors.yellow[800]),),
          SizedBox(height: 5,),
          TextFormField(
            autofocus: false,
            controller: widget.controller,
            style: TextStyle(fontSize: 18.0, color: Colors.yellow[800]),
            decoration: InputDecoration(
                filled: true,
                fillColor: CustomColors.secondaryBackground,
                hintText: widget.name,
                hintStyle: TextStyle(color: Colors.yellow[800].withOpacity(0.40)),
                prefixIcon: Icon(widget.iconData, color: Colors.yellow[800],),
                contentPadding: const EdgeInsets.only(left: 25.0, bottom: 12.0, top: 12.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.secondaryBackground),
                  borderRadius: BorderRadius.circular(25.7),
                )
            ),
          )
        ],
      ),
    );
  }
}
