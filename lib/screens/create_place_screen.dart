import 'dart:async';
import 'dart:io';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/components/tag.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/main.dart';

class CreatePlaceScreen extends StatefulWidget {
  static String id = UniqueKey().toString();
  Place? place;

  CreatePlaceScreen({Key? key, this.place}) : super(key: key);

  @override
  _CreatePlaceScreenState createState() => _CreatePlaceScreenState();
}

class _CreatePlaceScreenState extends State<CreatePlaceScreen> {
  late TextEditingController _placeNameController;
  late TextEditingController _tagController;
  late TextEditingController _descController;
  String _placeName = "";
  int _starPoint = 3; // 점수
  String _tag = ""; // 현재 입력중인 태그
  Set<String> _tags = {};
  DateTime _visitDate =
  DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController();
    _tagController = TextEditingController();
    _descController = TextEditingController();

    if (widget.place != null) {
      _placeNameController.text = widget.place!.name;
      _descController.text = widget.place!.desc;
      _tags = widget.place!.tags;
      _visitDate = widget.place!.visitDate;
      _starPoint = widget.place!.starPoint;
    }

    if (User.needHelp) {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        Timer(
            const Duration(milliseconds: 300),
                () =>
                ShowCaseWidget.of(context)!.startShowCase([
                  four,
                ]));
      });

      User.needHelp = false;
    }
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    _tagController.dispose();
    _descController.dispose(); // 자원 낭비를 막기 위해 dispose 권장
    super.dispose();
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
    return Wrap(
      spacing: 8.0, // 간격
      runSpacing: 3.0,
      children: tagCardList,
    );
  }

  Row _drawStarPoint(int starPoint) {
    List<Widget> starWidgetList = <Widget>[];
    for (var i = 1; i <= 5; i++) {
      if (starPoint >= i) {
        starWidgetList.add(GestureDetector(
          child: const Icon(
            Icons.star,
            size: 35.0,
          ),
          onTap: () {
            setState(() {
              _starPoint = i;
            });
          },
        ));
      } else {
        starWidgetList.add(GestureDetector(
          child: const Icon(
            Icons.star_border,
            size: 35.0,
          ),
          onTap: () {
            setState(() {
              _starPoint = i;
            });
          },
        ));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: starWidgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // textfield 전시되는 경우, 화면 겹치는 오류 해결
        appBar: AppBar(
          title: GestureDetector(
            child: Text(widget.place == null ? "그때 거기" : "그때 거기 [수정하기]"),
            onTap: () {
              Navigator.popUntil(
                  context, (route) => route.isFirst); // 첫 화면까지 pop
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Showcase(
                        key: four,
                        description:
                        "예전에 다녀왔는데 추가를 못 했다구?\n그럼 여길 누르면 날짜를 바꿀 수 있어!",
                        descTextStyle: kDefaultTextStyle,
                        child: TextButton(
                          child: Text(
                            _visitDate ==
                                DateTime(
                                    DateTime
                                        .now()
                                        .year,
                                    DateTime
                                        .now()
                                        .month,
                                    DateTime
                                        .now()
                                        .day)
                                ? "오늘"
                                : _visitDate ==
                                DateTime(
                                    DateTime
                                        .now()
                                        .year,
                                    DateTime
                                        .now()
                                        .month,
                                    DateTime
                                        .now()
                                        .day - 1)
                                ? "어제"
                                : "그때",
                            style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                          ),
                          onPressed: () async {
                            DateTime? value;
                            if (Platform.isAndroid) {
                              value = await showDatePicker(
                                  context: context,
                                  initialDate: _visitDate,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                            } else if (Platform.isIOS) {
                              value = await showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) =>
                                      CupertinoDatePicker(
                                          onDateTimeChanged: (val) {}));
                            }
                            if (value != null) {
                              setState(() {
                                _visitDate = DateTime(
                                    value!.year, value.month, value.day);
                              });
                            }
                          },
                        ),
                      ),
                      Text(
                        "방문한 곳 이름이 뭐야?",
                        style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                      ),
                    ],
                  ),
                  Focus(
                    onFocusChange: (val) {
                      if (val == false) {
                        // onSubmit에만 하면, 정말 제출했을 경우에만 실행되기 때문에, Focus 변경을 감지했다.

                        // 방문했던 장소중 한 개의 곳을 입력한 경우
                        // 새로운 장소를 만들면 안되고, 기존 장소의 방문 횟수를 늘려야 하므로 메시지를 표시한다.
                        // 메시지 표시와 함꼐 수정할 수 있도록 안내한다.
                        int index = List<String>.generate(
                            User.visitedPlaceList.length,
                                (index) => User.visitedPlaceList[index].name)
                            .indexOf(_placeNameController.text);
                        if (index > -1) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text(
                                "이전에 방문했던 장소입니다!",
                                style: kDefaultTextStyle,
                              )));
                          setState(() {
                            _starPoint = User.visitedPlaceList[index].starPoint;
                            _descController.text =
                                User.visitedPlaceList[index].desc;
                            _tags = User.visitedPlaceList[index].tags;
                          });
                        }
                      }
                    },
                    child: EasyAutocomplete(
                      controller: _placeNameController,
                      decoration: InputDecoration(
                        hintText: "장소 이름을 여기에 입력해줘!",
                        hintStyle: kDefaultTextStyle,
                        prefix: const Text("> "),
                        suffixText: "${_placeName.length}/$kPlaceNameMaxLength",
                        counterText: "",
                      ),
                      onChanged: (val) {
                        setState(() {
                          _placeName = val;
                        });
                      },
                      suggestions: List<String>.generate(
                          User.visitedPlaceList.length,
                              (index) => User.visitedPlaceList[index].name),
                      // 방문했던 장소를 토대로 suggestion 제시
                    ),
                  ), // 장소이름
                  const SizedBox(height: 30.0),
                  Text(
                    "관련된 단어들을 입력해줘!",
                    style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                  ),
                  Focus(
                    onFocusChange: (val) {
                      if (val == false) {
                        if (_tagController.text != "") {
                          setState(() {
                            _tag = _tagController.text;
                            _tags.add(_tag);
                            _tagController.text = "";
                            _tag = "";
                          });
                        }
                      }
                    },
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: "검색하기 편하도록 짧게! ex) 양식",
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
                    ),
                  ), // 태그 입력
                  const SizedBox(height: 5.0),
                  _drawTagCardList(_tags), // 태그
                  const SizedBox(height: 30.0),
                  Text(
                    "거기 어땠어?",
                    style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                  ),
                  TextField(
                    controller: _descController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "  어땠는지 적어줘!",
                      hintStyle: kDefaultTextStyle,
                    ),
                    maxLines: 3,
                    minLines: 3,
                  ), // 후기
                  const SizedBox(height: 30.0),
                  Text(
                    "5점 만점에 몇 점이야?",
                    style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                  ),
                  _drawStarPoint(_starPoint),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.send),
          onPressed: () {
            String name = _placeNameController.text;
            int starPoint = _starPoint;
            DateTime visitDate = _visitDate;
            Set<String> tags = _tags;
            String desc = _descController.text;
            desc = desc.replaceAll("\n", " ");

            if (name == "" || desc == "") {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("모든 항목을 입력해주세요!", style: kDefaultTextStyle)));
            } else if (tags.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("한 개 이상의 관련 단어를 입력해주세요!",
                      style: kDefaultTextStyle)));
            } else {
              if (widget.place == null) {
                Place place = Place(
                    name: name,
                    starPoint: starPoint,
                    visitDate: visitDate,
                    tags: tags,
                    desc: desc);
                int index = List<String>.generate(User.visitedPlaceList.length,
                        (index) => User.visitedPlaceList[index].name)
                    .indexOf(place.name);
                if (index > -1) {
                  // 기존 방문 장소일 경우
                  // 목록에서 제외했다가, 맨 처음으로 순서를 올림 (가장 최근 방문이므로)
                  place.visitCount =
                  ++User.visitedPlaceList[index].visitCount; // 방문 횟수 증가
                  User.visitedPlaceList.removeAt(index);
                }
                User.visitedPlaceList.insert(0, place);
                User.saveUser(); // 데이터 저장
                Navigator.pop(context);
              } else {
                // 수정하기
                setState(() {
                  widget.place!.name = name;
                  widget.place!.starPoint = starPoint;
                  widget.place!.visitDate = visitDate;
                  widget.place!.tags = tags;
                  widget.place!.desc = desc;
                });
                User.saveUser(); // 데이터 저장
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "수정되었습니다!",
                    style: kDefaultTextStyle,
                  ),
                ));
                Navigator.pop(context, widget.place!);
              }
            }
          },
        ),
      ),
    );
  }
}
