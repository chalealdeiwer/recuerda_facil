import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.green,
  Colors.blue,
  Colors.teal,
  Colors.red,
  Colors.purple,
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.yellow,
  Colors.amber,
  Colors.indigo,
  Colors.lime,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
  Colors.grey,
  Colors.brown,
  Colors.cyan,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.blueGrey,
  
];
const MaterialColor whiteSwatch = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const MaterialColor blackSwatch = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

class AppTheme{
  final int selectedColor;
  final bool isDarkMode;
  

  AppTheme( {
    this.isDarkMode=false,
    this.selectedColor = 0
  }):assert(selectedColor>=0 && selectedColor<colorList.length,'Selected color must be greater then 0');
  

  ThemeData getTheme()=> ThemeData(
    colorSchemeSeed: colorList[selectedColor],
    useMaterial3: true,
    brightness: isDarkMode? Brightness.dark: Brightness.light,
    appBarTheme: const AppBarTheme(
      centerTitle: false
    )
  );

  ThemeData getTheme2()=>ThemeData(
    // Colores primarios
    primarySwatch: blackSwatch,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,  // Si deseas un AppBar negro
        ),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: blackSwatch,
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
  );

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode

})=>AppTheme(selectedColor: selectedColor??this.selectedColor,isDarkMode: isDarkMode??this.isDarkMode);

}