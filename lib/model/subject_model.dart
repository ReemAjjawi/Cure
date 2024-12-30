
import 'dart:convert';

SubjectModel subjectModelFromJson(String str) => SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
    String name;
    int type;

    SubjectModel({
        required this.name,
        required this.type,
    });

    factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        name: json["name"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
    };
}
