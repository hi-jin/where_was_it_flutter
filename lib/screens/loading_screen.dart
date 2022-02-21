import 'dart:async';

import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/screens/main_screen.dart';

class LoadingScreen extends StatelessWidget {
  static String id = UniqueKey().toString();

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      Navigator.popAndPushNamed(context, MainScreen.id);
    });
    return Scaffold(
      body: Center(
        child: Text("로딩중입니다..."),
      ),
    );
  }
}
