import 'dart:developer';

import '../../../../core/utils/app_strings.dart';

class UserModel {
  String? accessToken;
  User? user;
  String? tokenType;
  String? expiresAt;

  UserModel({this.accessToken, this.user, this.tokenType, this.expiresAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'] != null
        ? " ${json['access_token'].contains(AppStrings.bearer) ? json['access_token'] : AppStrings.bearer + json['access_token']}"
        : "null";
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
    json['access_token'] != null
        ? log(json['access_token'])
        : log('nullllllllllll');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token_type'] = tokenType;
    data['expires_at'] = expiresAt;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? username;

  String? artworkUrl;
  String? permalinkUrl;
  bool? favorite;
  String? image;

  User({
    this.id,
    this.name,
    this.username,
    this.artworkUrl,
    this.permalinkUrl,
    this.favorite,
    this.image,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];

    image = json['image'];

    artworkUrl = json['artwork_url'];
    permalinkUrl = json['permalink_url'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;

    data['permalink_url'] = permalinkUrl;
    data['favorite'] = favorite;
    data['image'] = image;

    return data;
  }
}
