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

  bool _starPointOrder = false; // 별점순
  bool _visitDateOrder = true; // 방문순
  late List<Place> _placeList;
  bool _isListReversed = false; // placeList의 정렬 순서 변수

  void _setStarPointOrder() {
    if (!_starPointOrder) {
      _isListReversed = true;
      _placeList.sort((a, b) {
        return a.starPoint.compareTo(b.starPoint);
      });
    }
    setState(() {
      _starPointOrder = true;
      _visitDateOrder = false;
      _isListReversed = !_isListReversed;
      _placeList = List<Place>.from(_placeList.reversed);
    });
  }

  void _setVisitDateOrder() {
    if (!_visitDateOrder) {
      _isListReversed = true;
      _placeList.sort((a, b) {
        return a.visitDate.compareTo(b.visitDate);
      });
    }
    setState(() {
      _starPointOrder = false;
      _visitDateOrder = true;
      _isListReversed = !_isListReversed;
      _placeList = List<Place>.from(_placeList.reversed);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _placeList = [
      Place(
          name: "진구네 집밥",
          starPoint: 5,
          visitDate: DateTime(2021, 12, 2),
          tags: {"진구", "현준", "덮밥"}),
      Place(
          name: "역전할머니맥주",
          starPoint: 3,
          visitDate: DateTime(2022, 2, 22),
          tags: {"맥주", "술", "안주"}),
      Place(
          name: "진구네 집밥",
          starPoint: 2,
          visitDate: DateTime(2021, 12, 23),
          tags: {"진구", "현준", "덮밥"}),
      Place(
          name: "역전할머니맥주",
          starPoint: 4,
          visitDate: DateTime(2022, 2, 1),
          tags: {"맥주", "술", "안주"}),
      Place(
          name: "역전할머니맥주",
          starPoint: 1,
          visitDate: DateTime(2022, 2, 20),
          tags: {"맥주", "술", "안주"}),
    ];
    _placeList.sort((a, b) {
      return b.visitDate.compareTo(a.visitDate);
    }); // palceList 최근방문순으로 정렬
  }

  List<Widget> drawPlaceCardList(List<Place> placeList) {
    List<Widget> placeCardList = <Widget>[];

    for (Place place in placeList) {
      placeCardList.add(PlaceCard(place: place));
    }

    return placeCardList;
  } // TODO: placeList 받아오기

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
                    hintText: "기억나는 단어들을 여기에 입력해봐!",
                    hintStyle: kDefaultTextStyle,
                    prefix: Text("> "),
                  ),
                ), // 키워드 검색 텍스트필드
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: _starPointOrder
                              ? Colors.teal.shade100
                              : Theme.of(context).cardColor,
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: _starPointOrder && _isListReversed ? Text("낮은별점순"): Text("높은별점순"),
                      ),
                      onTap: () {
                        _setStarPointOrder();
                      },
                    ), // 높은 별점순 정렬 버튼
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: _visitDateOrder
                              ? Colors.teal.shade100
                              : Theme.of(context).cardColor,
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: _visitDateOrder && _isListReversed ? Text("과거방문순"): Text("최근방문순"),
                      ),
                      onTap: () {
                        _setVisitDateOrder();
                      },
                    ), // 최근 방문순 정렬 버튼
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: drawPlaceCardList(_placeList),
                  ),
                ), // 장소 카드 리스트
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
