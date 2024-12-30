// To parse this JSON data, do
//
//     final codeModel = codeModelFromJson(jsonString);

import 'dart:convert';

CodeModel codeModelFromJson(String str) => CodeModel.fromJson(json.decode(str));

String codeModelToJson(CodeModel data) => json.encode(data.toJson());

class CodeModel {
    int numberOfCodes;
    List<int> subjects;

    CodeModel({
        required this.numberOfCodes,
        required this.subjects,
    });

    factory CodeModel.fromJson(Map<String, dynamic> json) => CodeModel(
        numberOfCodes: json["number_of_codes"],
        subjects: List<int>.from(json["subjects"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "number_of_codes": numberOfCodes,
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
    };
}
