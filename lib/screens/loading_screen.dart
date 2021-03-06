import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/screens/main_screen.dart';

class LoadingScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    User.initUser();
    Timer(const Duration(seconds: 1, milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ShowCaseWidget(
                      builder: Builder(
                    builder: (context) => MainScreen(),
                  ))),
          (route) => route.isCurrent);
    }); // 데이터 로딩 완료 후 다음 화면 전시
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("로딩중입니다..."),
        ),
      ),
    );
  }
}
