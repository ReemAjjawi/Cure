// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';


@HiveType(typeId: 1) // Unique typeId for this model
class SubjectModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? type;

  @HiveField(3)
  int countOfLectures;

  SubjectModel({
    required this.id,
    this.name,
    this.type,
    required this.countOfLectures,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'countOfLectures': countOfLectures,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      countOfLectures: map['countOfLectures'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) => SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubjectModel(id: $id, name: $name, type: $type, countOfLectures: $countOfLectures)';
  }

  @override
  bool operator ==(covariant SubjectModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.countOfLectures == countOfLectures;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      countOfLectures.hashCode;
  }
}
