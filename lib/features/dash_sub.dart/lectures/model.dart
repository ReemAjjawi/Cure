// To parse this JSON data, do
//
//     final lectureModel = lectureModelFromJson(jsonString);

import 'dart:convert';

LectureModel lectureModelFromJson(String str) => LectureModel.fromJson(json.decode(str));

String lectureModelToJson(LectureModel data) => json.encode(data.toJson());

class LectureModel {
    int id;
    String name;
    int subjectId;
    DateTime createdAt;
    DateTime updatedAt;

    LectureModel({
        required this.id,
        required this.name,
        required this.subjectId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory LectureModel.fromJson(Map<String, dynamic> json) => LectureModel(
        id: json["id"],
        name: json["name"],
        subjectId: json["subject_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subject_id": subjectId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
