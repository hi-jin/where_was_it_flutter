import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/data/constants.dart';

class CreatePlaceScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const CreatePlaceScreen({Key? key}) : super(key: key);

  @override
  _CreatePlaceScreenState createState() => _CreatePlaceScreenState();
}

class _CreatePlaceScreenState extends State<CreatePlaceScreen> {
  late TextEditingController _placeNameController;
  String _placeName = "";

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // textfield 전시되는 경우, 화면 겹치는 오류 해결
      appBar: AppBar(
        title: GestureDetector(
          child: const Text("그때 거기"),
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst); // 첫 화면까지 pop
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Column(
          children: [
            Text(
              "오늘 방문한 곳은 어디야?",
              style: kDefaultTextStyle.copyWith(fontSize: 30.0),
            ),
            TextField(
              controller: _placeNameController,
              decoration: InputDecoration(
                hintText: "장소 이름을 여기에 입력해줘!",
                hintStyle: kDefaultTextStyle,
                prefix: Text("> "),
                suffixText: "${_placeName.length}/$kPlaceNameMaxLength",
                counterText: "",
              ),
              onChanged: (val) {
                setState(() {
                  _placeName = val;
                });
              },
              maxLength: kPlaceNameMaxLength, // counter text를 별도로 입력할 필요 없이, maxlength 사용 가능
            ),
          ],
        ),
      ),
    );
  }
}
