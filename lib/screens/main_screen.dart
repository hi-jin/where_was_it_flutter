import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("그때 거기"),
      ),
    );
  }
}
