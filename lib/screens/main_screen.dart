import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/components/place_card.dart';
import 'package:where_was_it_flutter/data/constants.dart';

class MainScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TextEditingController _searchController; // 검색창 textfield controller

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "그때 우리 어디 놀러 갔었지?",
                  style: kDefaultTextStyle.copyWith(fontSize: 30.0),
                ),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "기억나는 단어들을 띄어쓰기 해서 입력해봐!",
                    hintStyle: kDefaultTextStyle,
                    prefix: Text("> "),
                  ),
                ), // 키워드 검색 텍스트필드
                const SizedBox(height: 25.0),
                Expanded(
                  child: ListView(
                    children: [
                      PlaceCard(
                        place: Place(
                            name: "진구네 집밥",
                            starPoint: 5,
                            visitDate: DateTime(2021, 12, 2),
                            tags: {"진구", "현준", "덮밥"}),
                      ),
                      PlaceCard(
                        place: Place(
                            name: "역전할머니맥주",
                            starPoint: 3,
                            visitDate: DateTime(2022, 2, 22),
                            tags: {"맥주", "술", "안주"}),
                      ),
                      PlaceCard(
                        place: Place(
                            name: "진구네 집밥",
                            starPoint: 5,
                            visitDate: DateTime(2021, 12, 2),
                            tags: {"진구", "현준", "덮밥"}),
                      ),
                      PlaceCard(
                        place: Place(
                            name: "역전할머니맥주",
                            starPoint: 3,
                            visitDate: DateTime(2022, 2, 22),
                            tags: {"맥주", "술", "안주"}),
                      ),
                      PlaceCard(
                        place: Place(
                            name: "진구네 집밥",
                            starPoint: 5,
                            visitDate: DateTime(2021, 12, 2),
                            tags: {"진구", "현준", "덮밥"}),
                      ),
                      PlaceCard(
                        place: Place(
                            name: "역전할머니맥주",
                            starPoint: 3,
                            visitDate: DateTime(2022, 2, 22),
                            tags: {"맥주", "술", "안주"}),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
