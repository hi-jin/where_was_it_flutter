import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/components/tag.dart';
import 'package:where_was_it_flutter/data/constants.dart';

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
  late ScrollController _scrollController;
  String _placeName = "";
  int _starPoint = 3; // 점수
  String _tag = ""; // 현재 입력중인 태그
  Set<String> _tags = {};
  DateTime _visitDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController();
    _tagController = TextEditingController();
    _descController = TextEditingController();
    _scrollController = ScrollController();

    if (widget.place != null) {
      _placeNameController.text = widget.place!.name;
      _descController.text = widget.place!.desc;
      _tags = widget.place!.tags;
      _visitDate = widget.place!.visitDate;
      _starPoint = widget.place!.starPoint;
    }
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
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: Text(
                        _visitDate ==
                                DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)
                            ? "오늘"
                            : _visitDate ==
                                    DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day - 1)
                                ? "어제"
                                : "그때",
                        style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                      ),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: _visitDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            setState(() {
                              _visitDate =
                                  DateTime(value.year, value.month, value.day);
                            });
                          }
                        });
                      },
                    ),
                    Text(
                      "방문한 곳 이름이 뭐야?",
                      style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                    ),
                  ],
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
                  maxLength:
                      kPlaceNameMaxLength, // counter text를 별도로 입력할 필요 없이, maxlength 사용 가능
                ), // 장소이름
                const SizedBox(height: 30.0),
                Text(
                  "관련된 단어들을 입력해줘!",
                  style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                ),
                TextField(
                  controller: _tagController,
                  decoration: InputDecoration(
                    hintText: "예시) 양식",
                    hintStyle: kDefaultTextStyle,
                    prefix: Text("> "),
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
                    });
                  },
                ),
                const SizedBox(height: 5.0),
                _drawTagCardList(_tags), // 태그
                const SizedBox(height: 30.0),
                Text(
                  "거기 어땠어?",
                  style: kDefaultTextStyle.copyWith(fontSize: 25.0),
                ),
                TextField(
                  controller: _descController,
                  onTap: () {
                    Timer(Duration(milliseconds: 300), () {
                      _scrollController.animateTo(500.0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {
            if (widget.place == null) {
              // TODO 추가하기

            } else {
              // 수정하기
              setState(() {
                widget.place!.setName(_placeNameController.text);
                widget.place!.setStarPoint(_starPoint);
                widget.place!.setVisitDate(_visitDate);
                widget.place!.setTags(_tags);
                widget.place!.setDesc(_descController.text);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("수정되었습니다!", style: kDefaultTextStyle,),
              ));
            }
            Navigator.pop(context, widget.place!);
          },
        ),
      ),
    );
  }
}
