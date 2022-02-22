import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/screens/create_place_screen.dart';
import 'package:where_was_it_flutter/screens/loading_screen.dart';
import 'package:where_was_it_flutter/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: Colors.teal),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
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
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(),
        MainScreen.id: (context) => MainScreen(),
        CreatePlaceScreen.id: (context) => CreatePlaceScreen(),
      },
    );
  }
}
