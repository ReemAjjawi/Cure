// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogInModel {
  String phone_number;
  String? password;
  String code;
  LogInModel({
    required this.phone_number,
    required this.password,
    required this.code,
  });

  LogInModel copyWith({
    String? phone_number,
    String? password,
    String? code,
  }) {
    return LogInModel(
      phone_number: phone_number ?? this.phone_number,
      password: password ?? this.password,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone_number': phone_number,
      'password': password,
      'code': code,
    };
  }

  factory LogInModel.fromMap(Map<String, dynamic> map) {
    return LogInModel(
      phone_number: map['phone_number'] as String,
      password: map['password'] as String,
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogInModel.fromJson(String source) =>
      LogInModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LogInModel(phone_number: $phone_number, password: $password, code: $code)';

  @override
  bool operator ==(covariant LogInModel other) {
    if (identical(this, other)) return true;

    return other.phone_number == phone_number &&
        other.password == password &&
        other.code == code;
  }

  @override
  int get hashCode => phone_number.hashCode ^ password.hashCode ^ code.hashCode;
}
