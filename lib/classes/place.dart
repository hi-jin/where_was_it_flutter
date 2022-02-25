import 'dart:convert';

class Place {
  String name; // 15글자 제한
  int starPoint;
  DateTime visitDate;
  Set<String> tags;
  String desc;
  int visitCount = 1;

  Place({required this.name,
    required this.starPoint,
    required this.visitDate,
    required this.tags,
    this.desc = ""});

  String toJson() {
    return jsonEncode({
      "name": name,
      "starPoint": starPoint,
      "visitDate": visitDate.toString(),
      "tags": tags.toList(),
      "desc": desc,
      "visitCount": visitCount,
    });
  }

  static Place fromJson(Map<String, dynamic> placeData) {
    Place place = Place(
      name: placeData["name"],
      starPoint: placeData["starPoint"],
      visitDate: DateTime.parse(placeData["visitDate"]),
      tags: Set<String>.from(placeData["tags"]),
      desc: placeData["desc"],
    );
    place.visitCount = placeData["visitCount"];
    return place;
  }
}
