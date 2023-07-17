import 'dart:convert';

DonationModel donationModelFromJson(String str) =>
    DonationModel.fromJson(json.decode(str));

String donationModelToJson(DonationModel data) => json.encode(data.toJson());

class DonationModel {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;
  int? disasterId;
  String? name;
  String? age;
  String? contactNumber;
  String? email;
  String? donationType;
  String? donationInfo;
  int? verified;
  String? goodsType;

  DonationModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.disasterId,
    required this.name,
    required this.age,
    required this.contactNumber,
    required this.email,
    required this.donationType,
    required this.donationInfo,
    required this.verified,
    required this.goodsType,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) => DonationModel(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        disasterId: json["disaster_id"],
        name: json["name"],
        age: json["age"],
        contactNumber: json["contact_number"],
        email: json["email"],
        donationType: json["donation_type"],
        donationInfo: json["donation_info"],
        verified: json["verified"],
        goodsType: json["goods_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "user_id": userId,
        "disaster_id": disasterId,
        "name": name,
        "age": age,
        "contact_number": contactNumber,
        "email": email,
        "donation_type": donationType,
        "donation_info": donationInfo,
        "verified": verified,
        "goods_type": goodsType
      };
}
