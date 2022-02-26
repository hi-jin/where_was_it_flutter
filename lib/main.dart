import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/data/color_styles.dart';
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ko", "KR"),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: User.selectedColorTheme.primary),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: User.selectedColorTheme.accent,
        ),
        textTheme: TextTheme(
          headline6: kDefaultTextStyle.copyWith(fontSize: 30.0),
          // appBar.title
          subtitle1: kDefaultTextStyle,
          // ListTile.title
          bodyText2: kDefaultTextStyle, // default
        ),
        iconTheme: IconThemeData(color: User.selectedColorTheme.darkPrimary),
      ),
      home: const LoadingScreen(),
    );
  }
}
