import 'dart:async';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/components/place_card.dart';
import 'package:where_was_it_flutter/components/tag.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/main.dart';

import 'create_place_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = UniqueKey().toString();

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;
  late AnimationController _animationController;
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
    }
    setState(() {
      if (_isListReversed) {
        _placeList.sort((a, b) {
          return b.starPoint.compareTo(a.starPoint);
        });
      } else {
        _placeList.sort((a, b) {
          return a.starPoint.compareTo(b.starPoint);
        });
      }
      _starPointOrder = true;
      _visitDateOrder = false;
      _isListReversed = !_isListReversed;
    });
  }

  void _setVisitDateOrder() {
    if (!_visitDateOrder) {
      _isListReversed = true;
    }
    setState(() {
      if (_isListReversed) {
        _placeList.sort((a, b) {
          return b.visitDate.compareTo(a.visitDate);
        });
      } else {
        _placeList.sort((a, b) {
          return a.visitDate.compareTo(b.visitDate);
        });
      }
      _starPointOrder = false;
      _visitDateOrder = true;
      _isListReversed = !_isListReversed;
    });
  }

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _slideAnimation = Tween<Offset>(
            begin: const Offset(0.0, 5.0), end: const Offset(0.05, 0.0))
        .animate(_animationController);

    _rotateAnimation =
        Tween<double>(begin: 0.0, end: 0.62).animate(_animationController);

    if (User.needHelp) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Timer(const Duration(milliseconds: 300),
            () => ShowCaseWidget.of(context)!.startShowCase([one, two]));
      });
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _help() {
    User.needHelp = true;
    ShowCaseWidget.of(context)!.startShowCase([one, two]);
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
  }

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
      List<Place> searchedList = List<Place>.from(User.visitedPlaceList.where(
          (element) =>
              element.tags.containsAll(_tags) || _tags.contains(element.name)));
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
                    Showcase(
                      key: one,
                      description: '두 번 클릭해서 반대로 정렬할 수 있어!',
                      descTextStyle: kDefaultTextStyle,
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: _starPointOrder
                                ? User.selectedColorTheme.lightPrimary
                                : Theme.of(context).cardColor,
                            border: Border.all(
                                color: User.selectedColorTheme.primary),
                          ),
                          child: _starPointOrder && _isListReversed
                              ? const Text("낮은별점순")
                              : const Text("높은별점순"),
                        ),
                        onTap: () {
                          _setStarPointOrder();
                        },
                      ),
                    ), // 높은 별점순 정렬 버튼
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: _visitDateOrder
                              ? User.selectedColorTheme.lightPrimary
                              : Theme.of(context).cardColor,
                          border: Border.all(
                              color: User.selectedColorTheme.primary),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: TextButton(
              child: PhysicalModel(
                color: User.selectedColorTheme.accent,
                shadowColor: Colors.grey,
                elevation: 6.0,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 50.0,
                  width: 120.0,
                  child: Center(
                      child: Text(
                    "도움말",
                    style: kDefaultTextStyle.copyWith(color: Colors.black),
                  )),
                ),
              ),
              onPressed: () {
                _animationController.reverse();
                _help();
              },
            ),
          ), // 도움말
          SlideTransition(
            position: _slideAnimation,
            child: TextButton(
              child: PhysicalModel(
                color: User.selectedColorTheme.accent,
                shadowColor: Colors.grey,
                elevation: 6.0,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 50.0,
                  width: 120.0,
                  child: Center(
                      child: Text(
                    "방문 기록하기",
                    style: kDefaultTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              onPressed: () async {
                _animationController.reverse();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowCaseWidget(
                                builder: Builder(
                              builder: (context) => CreatePlaceScreen(),
                            ))));
                setState(() {
                  _placeList = User.visitedPlaceList; // 화면 업데이트를 위해 새로 받아옴
                });
              },
            ),
          ), // 방문 기록하기
          const SizedBox(height: 10.0),
          Showcase(
            key: two,
            description:
                '놀러갔던 장소를 기록할 수 있어!\n1.새로운 장소  2. 기존에 방문했던 장소\n기존 장소를 다시 입력하면, 방문 횟수와 최근 방문 일자가 기록돼!',
            descTextStyle: kDefaultTextStyle,
            child: FloatingActionButton(
              child: RotationTransition(
                turns: _rotateAnimation,
                child: const Icon(
                  Icons.add,
                  size: 30.0,
                ),
              ),
              onPressed: () {
                if (_animationController.status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
