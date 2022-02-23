import 'package:where_was_it_flutter/classes/place.dart';

class PlaceManager {
  static List<Place> getPlaceListFromFile() {
    List<Place> placeList = <Place>[
      Place(
          name: "진구네 집밥",
          starPoint: 5,
          visitDate: DateTime(2021, 12, 2),
          tags: {"진구", "현준", "덮밥"},
          desc: "국밥이 참 친절하고 사장님이 맛있어요"),
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

    placeList.sort((a, b) {
      return b.visitDate.compareTo(a.visitDate);
    }); // palceList 최근방문순으로 정렬

    return placeList;
  } // TODO: Storage이용하기
}