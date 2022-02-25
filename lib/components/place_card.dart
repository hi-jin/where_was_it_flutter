import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/classes/user.dart';
import 'package:where_was_it_flutter/data/constants.dart';
import 'package:where_was_it_flutter/screens/create_place_screen.dart';
import 'package:word_break_text/word_break_text.dart';

class PlaceCard extends StatefulWidget {
  Place place;

  PlaceCard({Key? key, required this.place}) : super(key: key);

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  Widget drawStarPoint(int starPoint) {
    List<Widget> starWidgetList = <Widget>[];
    for (var i = 1; i <= 5; i++) {
      if (starPoint >= i) {
        starWidgetList.add(const Icon(Icons.star));
      } else {
        starWidgetList.add(const Icon(Icons.star_border));
      }
    }

    return Row(children: starWidgetList);
  }

  @override
  Widget build(BuildContext context) {
    String placeName = widget.place.name;
    int starPoint = widget.place.starPoint;
    DateTime visitDate = widget.place.visitDate;
    Set<String> tags = widget.place.tags;
    int visitCount = widget.place.visitCount;
    String desc = widget.place.desc;

    return Card(
      child: GestureDetector(
        onTap: () {
          if (desc == "") desc = " ";
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(placeName),
                  content: WordBreakText(desc),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePlaceScreen(
                                        place: widget.place,
                                      ))).then((value) {
                            if (value != null) {
                              setState(() {
                                widget.place = value;
                              });
                            }
                          });
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Text(
                          "수정하기",
                          style: kDefaultTextStyle,
                        )),
                  ],
                );
              });
        },
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(placeName),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawStarPoint(starPoint),
              WordBreakText("#${tags.join(" #")}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "최근 방문 ${visitDate.month}월 ${visitDate.day}일, ${visitDate.year}"),
                  Text("방문 횟수 $visitCount회")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
