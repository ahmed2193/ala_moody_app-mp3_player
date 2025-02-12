class RegisterModel {
  String? accessToken;
  String? tokenType;
  String? expiresAt;

  RegisterModel({this.accessToken, this.tokenType, this.expiresAt});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
  }
}
