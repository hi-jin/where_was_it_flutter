import 'package:where_was_it_flutter/classes/place.dart';
import 'package:where_was_it_flutter/classes/place_manager.dart';

class User {
  // 지금까지 방문했던 장소 리스트
  static List<Place> visitedPlaceList = <Place>[];

  static void initUser() {
    visitedPlaceList = PlaceManager.getPlaceListFromFile();
  }
}
