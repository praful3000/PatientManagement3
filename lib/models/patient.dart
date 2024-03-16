// To parse this JSON data, do
//
//     final allPatients = allPatientsFromJson(jsonString);

import 'dart:convert';

import 'package:patient_management/models/patient_records.dart';

AllPatients allPatientsFromJson(String str) =>
    AllPatients.fromJson(json.decode(str));

String allPatientsToJson(AllPatients data) => json.encode(data.toJson());

class AllPatients {
  final bool? success;
  final String? message;
  final Data? data;

  AllPatients({
    this.success,
    this.message,
    this.data,
  });

  factory AllPatients.fromJson(Map<String, dynamic> json) => AllPatients(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final int? currentPage;
  final List<Patient>? patient;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  Data({
    this.currentPage,
    this.patient,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        patient: json["data"] == null
            ? []
            : List<Patient>.from(json["data"]!.map((x) => Patient.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": patient == null
            ? []
            : List<dynamic>.from(patient!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Patient {
  final int? id;
  final String? name;
  final String? address;
  final DateTime? dob;
  final String? gender;
  final String? phone;
  final String? ward;
  final String? description;
  final String? conditions;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? age;
  List<Records>? records;

  Patient(
      {this.id,
      this.name,
      this.address,
      this.dob,
      this.gender,
      this.phone,
      this.ward,
      this.description,
      this.conditions,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.age,
      this.records});

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      gender: json["gender"],
      phone: json["phone"],
      ward: json["ward"],
      description: json["description"],
      conditions: json["conditions"],
      image: json["image"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      age: json["age"],
      records: []);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "dob": dob?.toIso8601String(),
        "gender": gender,
        "phone": phone,
        "ward": ward,
        "description": description,
        "conditions": conditions,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "age": age,
        "records": []
      };
}
