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


class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({required this.isDarkMode, required this.selectedColor})
      : assert(selectedColor >= 0 && selectedColor < colorList.length,
            'Selected color must be greater then 0');

  ThemeData getTheme() => ThemeData(
      colorSchemeSeed: colorList[selectedColor],
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      appBarTheme: const AppBarTheme(centerTitle: false));

  

  AppTheme copyWith({int? selectedColor, bool? isDarkMode}) => AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode);
}
