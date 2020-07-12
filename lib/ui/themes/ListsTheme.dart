import 'package:flutter/material.dart';

class ListsTheme {
  bool isDark;
  Color primaryColor;

  static const double _appBarTextFontSize    = 18;
  static const double _listItemLabelFontSize = 18;
  static const double _listItemCountFontSize = 14;

  ListsTheme({ @required this.isDark, @required this.primaryColor });

  ThemeData get themeData {
    return ThemeData(
      brightness:               Brightness.light,
      primarySwatch:            _getMaterialColor(primaryColor),
      textTheme:                isDark ? _getDarkTextTheme() : _getLightTextTheme(),
      scaffoldBackgroundColor:  isDark ? const Color(0xFF333333) : const Color(0xFFEFEFEF),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Color(0xF5FAFAFA)
      ),
      visualDensity:              VisualDensity.adaptivePlatformDensity
    );
  }

  TextTheme _getLightTextTheme() {
    return Typography.blackMountainView.copyWith(
      headline1: TextStyle(
        fontSize: _appBarTextFontSize,
        fontWeight: FontWeight.w500,
        color: Color(0xF5FAFAFA)
      ),
      bodyText1: TextStyle(
        fontSize: _listItemLabelFontSize, 
        color: Color(0xD0161616),
        fontWeight: FontWeight.w400
      ),
      bodyText2: TextStyle(
        fontSize: _listItemCountFontSize,
        color:      Color(0x90161616),
        fontStyle: FontStyle.italic
      ),
    );
  }

  TextTheme _getDarkTextTheme() {
    return Typography.whiteMountainView.copyWith(
      headline1: TextStyle(
        fontSize:   _appBarTextFontSize,
        fontWeight: FontWeight.w500,
        color:      Color(0xF5FAFAFA)
      ),
      bodyText1: TextStyle(
        fontSize:   _listItemLabelFontSize, 
        color:      Color(0xFFF5F5F5),
        fontWeight: FontWeight.w400
      ),
      bodyText2: TextStyle(
        fontSize:   _listItemCountFontSize,
        color:      Color(0xFFA1B1C1),
        fontStyle:  FontStyle.italic
      ),
    );
  }

  MaterialColor _getMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      swatch[(strength * 1000).round()] = Color.fromRGBO(r, g, b, 1);

      //final double ds = 0.5 - strength;
      //swatch[(strength * 1000).round()] = Color.fromRGBO(
      //  r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      //  g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      //  b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      //  1,
      //);
    });
    return MaterialColor(color.value, swatch);
  }
}
