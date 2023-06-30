// To parse this JSON data, do
//
//     final authenticationModel = authenticationModelFromJson(jsonString);

import 'dart:convert';

AuthenticationModel authenticationModelFromJson(String str) =>
    AuthenticationModel.fromJson(json.decode(str));

String authenticationModelToJson(AuthenticationModel data) =>
    json.encode(data.toJson());

class AuthenticationModel {
  int? id;
  String? name;
  String? email;
  String? filename;
  String? path;
  int? verified;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic userType;

  AuthenticationModel({
    required this.id,
    required this.name,
    required this.email,
    required this.filename,
    required this.path,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    this.userType,
  });

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        filename: json["filename"],
        path: json["path"],
        verified: json["verified"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userType: json["user_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "filename": filename,
        "path": path,
        "verified": verified,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user_type": userType,
      };
}
