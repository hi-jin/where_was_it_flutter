import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/components/place_card.dart';
import 'package:where_was_it_flutter/components/tag.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/screens/create_place_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TextEditingController _tagController;
  late List<Place> _placeList = User.visitedPlaceList;

  bool _starPointOrder = false; // 별점순
  bool _visitDateOrder = true; // 방문순
  bool _isListReversed = false; // placeList의 정렬 순서 변수

  String _tag = ""; // 현재 입력중인 태그
  final Set<String> _tags = {};

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
    _tagController = TextEditingController();
  }

  List<Widget> drawPlaceCardList(List<Place> placeList) {
    List<Widget> placeCardList = <Widget>[];

    for (var i = 0; i < placeList.length; i++) {
      placeCardList.add(PlaceCard(
        place: placeList[i],
        removeCard: () {
          setState(() {
            placeCardList.removeAt(i);
            _placeList.removeAt(i);
            User.saveUser();
          });
        },
      ));
    }

    return placeCardList;
  } // TODO: placeList 받아오기


  Wrap _drawTagCardList(Set<String> tags) {
    List<Widget> tagCardList = <Widget>[];
    for (String tag in tags) {
      tagCardList.add(TagCard(
        tag: tag,
        removeTagFunc: () {
          setState(() {
            _tags.remove(tag);
          });
        },
      ));
    }

    if (tags.isEmpty) {
      _placeList = User.visitedPlaceList;
    } else {
      List<Place> searchedList = List<Place>.from(User.visitedPlaceList.where((element) => element.tags.containsAll(_tags) || _tags.contains(element.name)));
      searchedList.sort((a, b) {
        if (_tags.contains(a.name)) {
          return -1;
        } else {
          return 1;
        }
      });
      setState(() {
        _placeList = searchedList;
      });
    }

    return Wrap(
      spacing: 8.0, // 간격
      runSpacing: 3.0,
      children: tagCardList,
    );
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
                  controller: _tagController,
                  decoration: InputDecoration(
                    hintText: "기억나는 단어들을 여기에 입력해봐!",
                    hintStyle: kDefaultTextStyle,
                    prefix: const Text("> "),
                    suffixText: "${_tag.length}/$kPlaceNameMaxLength",
                    counterText: "",
                  ),
                  onChanged: (val) {
                    setState(() {
                      _tag = val;
                    });
                  },
                  maxLength: kPlaceNameMaxLength,
                  // counter text를 별도로 입력할 필요 없이, maxlength 사용 가능
                  onSubmitted: (val) {
                    if (val == "") return;
                    setState(() {
                      _tags.add(val);
                      _tagController.text = "";
                      _tag = "";
                    });
                  },
                ), // 검색 태그 입력
                const SizedBox(height: 5.0),
                _drawTagCardList(_tags), // 태그
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: _starPointOrder
                              ? Colors.teal.shade100
                              : Theme.of(context).cardColor,
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: _starPointOrder && _isListReversed
                            ? const Text("낮은별점순")
                            : const Text("높은별점순"),
                      ),
                      onTap: () {
                        _setStarPointOrder();
                      },
                    ), // 높은 별점순 정렬 버튼
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: _visitDateOrder
                              ? Colors.teal.shade100
                              : Theme.of(context).cardColor,
                          border: Border.all(color: Colors.teal.shade100),
                        ),
                        child: _visitDateOrder && _isListReversed
                            ? const Text("과거방문순")
                            : const Text("최근방문순"),
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
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, CreatePlaceScreen.id);
          setState(() {
            _placeList = User.visitedPlaceList; // 화면 업데이트를 위해 새로 받아옴
          });
        },
      ),
    );
  }
}
