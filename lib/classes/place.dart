class Place {
  String name; // 15글자 제한
  int starPoint;
  DateTime visitDate;
  Set<String> tags;

  Place({required this.name, required this.starPoint, required this.visitDate, required this.tags});

  set setName(String name) {
    if (name.length > 15) throw Exception("name length must be less than or equal to 15");
    this.name = name;
  }

  set setStarPoint(int starPoint) {
    if (starPoint < 0 || starPoint > 5) throw Exception("starPoint must be an integer between 0 and 5");
    this.starPoint = starPoint;
  }

  set setVisitDate(DateTime visitDate) {
    this.visitDate = visitDate;
  }

  set setTags(Iterable<String> tags) {
    this.tags = <String>{};
    this.tags.addAll(tags);
  }

  set addTag(String tag) {
    tags.add(tag);
  }
}