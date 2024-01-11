List<dynamic> temporaryGroupDB() {
  List<dynamic> group = [];
  Map<String, dynamic> newGroup = {
    "id": 123,
    "name": "TestGroup1",
    "studentsId": <int>[1, 2, 3],
  };
  group.add(newGroup);
  newGroup = {
    "id": 456,
    "name": "TestGroup2",
    "studentsId": <int>[],
  };
  group.add(newGroup);
  return group;
}
