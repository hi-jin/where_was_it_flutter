class Place {
  String name; // 15글자 제한
  int starPoint;
  DateTime visitDate;
  Set<String> tags;
  String desc;
  int visitCount = 0;

  Place({required this.name, required this.starPoint, required this.visitDate, required this.tags, this.desc = ""});

  void setName(String name) {
    if (name.length > 15) throw Exception("name length must be less than or equal to 15");
    this.name = name;
  }

  void setStarPoint(int starPoint) {
    if (starPoint < 0 || starPoint > 5) throw Exception("starPoint must be an integer between 0 and 5");
    this.starPoint = starPoint;
  }

  void setVisitDate(DateTime visitDate) {
    this.visitDate = visitDate;
  }

  void setTags(Iterable<String> tags) {
    this.tags = <String>{};
    this.tags.addAll(tags);
  }

  void addTag(String tag) {
    tags.add(tag);
  }

  void setVisitCount(int visitCount) {
    this.visitCount = visitCount;
  }

  void addVisitCount() {
    visitCount++;
  }

  void setDesc(String desc) {
    this.desc = desc;
  }
}