import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

InputDecoration getItemDecorationForField({@required String hintText, @required IconData iconData}) {
  return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      prefixIcon: Icon(iconData, color: Colors.grey[800],),
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(25.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(25.7),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 3),
        borderRadius: BorderRadius.circular(25.7),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 3),
        borderRadius: BorderRadius.circular(25.7),
      )
  );
}