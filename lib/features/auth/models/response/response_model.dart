// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Login {
  Data data;
  int status;
  Login({
    required this.data,
    required this.status,
  });

  Login copyWith({
    Data? data,
    int? status,
  }) {
    return Login(
      data: data ?? this.data,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.toMap(),
      'status': status,
    };
  }

  factory Login.fromMap(Map<String, dynamic> map) {
    return Login(
      data: Data.fromMap(map['data'] as Map<String,dynamic>),
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Login.fromJson(String source) => Login.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Login(data: $data, status: $status)';

  @override
  bool operator ==(covariant Login other) {
    if (identical(this, other)) return true;
  
    return 
      other.data == data &&
      other.status == status;
  }

  @override
  int get hashCode => data.hashCode ^ status.hashCode;
}

class Data {
  String message;
  String token;
  Data({
    required this.message,
    required this.token,
  });

  Data copyWith({
    String? message,
    String? token,
  }) {
    return Data(
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'token': token,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      message: map['message'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) => Data.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Data(message: $message, token: $token)';

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
      other.token == token;
  }

  @override
  int get hashCode => message.hashCode ^ token.hashCode;
}
