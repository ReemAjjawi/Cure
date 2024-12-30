// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class SubjectModel {
  int? id;
  String? name;
  String? type;
  int countOfLectures;
  SubjectModel({
    this.id,
    this.name,
    this.type,
    required this.countOfLectures,
  });

  SubjectModel copyWith({
    int? id,
    String? name,
    String? type,
    int? countOfLectures,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      countOfLectures: countOfLectures ?? this.countOfLectures,
    );
  }

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
      id: map['id'] != null ? map['id'] as int : null,
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
