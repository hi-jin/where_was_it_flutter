import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/screens/loading_screen.dart';

GlobalKey one = GlobalKey();
GlobalKey two = GlobalKey();
GlobalKey three = GlobalKey();
GlobalKey four = GlobalKey();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.teal),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
        textTheme: TextTheme(
          headline6: kDefaultTextStyle.copyWith(fontSize: 30.0),
          // appBar.title
          subtitle1: kDefaultTextStyle,
          // ListTile.title
          bodyText2: kDefaultTextStyle, // default
        ),
        iconTheme: IconThemeData(color: Colors.teal.shade700),
      ),
      home: const LoadingScreen(),
    );
  }
}
