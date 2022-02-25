import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:where_was_it_flutter/classes/place.dart';

class User {
  // 지금까지 방문했던 장소 리스트
  static List<Place> visitedPlaceList = <Place>[];

  static bool needHelp = false;

  static void initUser() async {
    visitedPlaceList = await _getPlaceListFromFile();
  }

  static Future<List<Place>> _getPlaceListFromFile() async {
    List<Place> placeList = [];

    try {
      Directory documents = await getApplicationDocumentsDirectory();
      File userFile = File("${documents.path}/user.txt");

      String jsonData = await userFile.readAsString();

      List data = jsonDecode(jsonData);

      for (var stringPlace in data) {
        placeList.add(Place.fromJson(stringPlace));
      }
    } catch (e) {
      needHelp = true;
      placeList = <Place>[
        Place(
          name: "그냥맛집",
          starPoint: 4,
          visitDate: DateTime(2022, 2, 25),
          tags: {"파스타", "피자", "양식", "물"},
          desc: "양식 맛집인데, 물이 제일 맛있다.",
        )
      ];
    }

    return placeList;
  }

  static void saveUser() async {
    visitedPlaceList.sort((a, b) {
      return b.visitDate.compareTo(a.visitDate);
    }); // palceList 최근방문순으로 정렬

    Directory documents = await getApplicationDocumentsDirectory();
    File userFile = File("${documents.path}/user.txt");

    List data = [];
    for (Place place in visitedPlaceList) {
      data.add(place.toJson());
    }

    userFile.writeAsString(data.toString());
  }
}
