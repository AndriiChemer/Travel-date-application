import 'dart:ui';

class CustomColors {

  static Color toolbarBackground = fromHex("#2D2D2D");
  static Color bottomBackground = fromHex("#2D2D2D");
  static Color personItemBackground = fromHex("#2D2D2D");
  static Color mainBackground = fromHex("#333333");

  static Color fromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    return Color(int.parse('FF' + hexColor, radix: 16));
  }
}