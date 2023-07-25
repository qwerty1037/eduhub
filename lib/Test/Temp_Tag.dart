import 'package:flutter/material.dart';

List<String> tags = [
  "수학1",
  "수학2",
  "미적분1",
  "미적분2",
  "기하와 벡터",
  "확률과 통계",
];

class Tag {
  Tag({
    required this.id,
    required this.name,
    required this.problemCount,
    required this.ownerId,
  });
  int? id;
  String name;
  int problemCount;
  int? ownerId;
  //id: number, name: string, problemCount: number, ownerId: number
}
