import 'dart:convert';

FeedModel feedModelFromJson(String str) => FeedModel.fromJson(json.decode(str));

String feedModelToJson(FeedModel data) => json.encode(data.toJson());

class FeedModel {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  String? title;
  String? date;
  String? disasterType;
  String? location;
  String? information;
  String? filename;
  String? path;

  FeedModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.title,
    required this.date,
    required this.disasterType,
    required this.location,
    required this.information,
    required this.filename,
    required this.path,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        title: json["title"],
        date: json["date"],
        disasterType: json["disasterType"],
        location: json["location"],
        information: json["information"],
        filename: json["filename"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user_id": userId,
        "title": title,
        "date": date,
        "disasterType": disasterType,
        "location": location,
        "information": information,
        "filename": filename,
        "path": path,
      };
}
