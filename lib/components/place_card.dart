import 'package:flutter/material.dart';
import 'package:where_was_it_flutter/classes/place.dart';
import 'package:word_break_text/word_break_text.dart';

class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({Key? key, required this.place}) : super(key: key);

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
    String placeName = place.name;
    int starPoint = place.starPoint;
    DateTime visitDate = place.visitDate;
    Set<String> tags = place.tags;

    return Card(
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
            Text(
                "최근 방문 ${visitDate.month}월 ${visitDate.day}일, ${visitDate.year}"),
          ],
        ),
      ),
    );
  }
}
