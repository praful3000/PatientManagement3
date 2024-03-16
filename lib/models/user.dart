// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic address;
  String? role;
  int? isBlocked;
  String? avatar;
  String? token;
  bool? emailVerified;
  bool? phoneVerified;
  dynamic createdAt;
  dynamic updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.role,
    this.isBlocked,
    this.avatar,
    this.token,
    this.emailVerified,
    this.phoneVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"] ?? '',
        role: json["role"],
        isBlocked: json["isBlocked"],
        avatar: json["avatar"],
        token: json["token"],
        emailVerified: json["email_verified"],
        phoneVerified: json["phone_verified"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "role": role,
        "isBlocked": isBlocked,
        "avatar": avatar,
        "token": token,
        "email_verified": emailVerified,
        "phone_verified": phoneVerified,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
