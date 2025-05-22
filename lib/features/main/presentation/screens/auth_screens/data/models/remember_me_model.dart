import 'dart:convert';

RememberMeModel rememberMeModelFromJson(String str) =>
    RememberMeModel.fromJson(json.decode(str));

String rememberMeModelToJson(RememberMeModel data) =>
    json.encode(data.toJson());

class RememberMeModel {
  RememberMeModel({
    this.username,
    this.email,
    this.password,
  });

  RememberMeModel.fromJson(dynamic json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  String? username;
  String? email;
  String? password;

  RememberMeModel copyWith({
    String? username,
    String? email,
    String? password,
  }) =>
      RememberMeModel(
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}
