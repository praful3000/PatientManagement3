// To parse this JSON data, do
//
//     final allPatientsRecords = allPatientsRecordsFromJson(jsonString);

import 'dart:convert';

import 'package:patient_management/models/patient.dart';

AllPatientsRecords allPatientsRecordsFromJson(String str) =>
    AllPatientsRecords.fromJson(json.decode(str));

String allPatientsRecordsToJson(AllPatientsRecords data) =>
    json.encode(data.toJson());

class AllPatientsRecords {
  final bool? success;
  final String? message;
  final Data? data;

  AllPatientsRecords({
    this.success,
    this.message,
    this.data,
  });

  factory AllPatientsRecords.fromJson(Map<String, dynamic> json) =>
      AllPatientsRecords(
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
  final List<Records>? records;
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
    this.records,
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
        records: json["data"] == null
            ? []
            : List<Records>.from(json["data"]!.map((x) => Records.fromJson(x))),
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
        "data": records == null
            ? []
            : List<dynamic>.from(records!.map((x) => x.toJson())),
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

class Records {
  final int? id;
  final int? patientId;
  final String? bloodPressure;
  final String? respiratoryRate;
  final String? bloodOxygen;
  final String? heartBeat;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Patient? patient;

  Records({
    this.id,
    this.patientId,
    this.bloodPressure,
    this.respiratoryRate,
    this.bloodOxygen,
    this.heartBeat,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.patient,
  });

  factory Records.fromJson(Map<String, dynamic> json) => Records(
        id: json["id"],
        patientId: json["patient_id"],
        bloodPressure: json["blood_pressure"],
        respiratoryRate: json["respiratory_rate"],
        bloodOxygen: json["blood_oxygen"],
        heartBeat: json["heart_beat"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        patient:
            json["patient"] == null ? null : Patient.fromJson(json["patient"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "blood_pressure": bloodPressure,
        "respiratory_rate": respiratoryRate,
        "blood_oxygen": bloodOxygen,
        "heart_beat": heartBeat,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "patient": patient?.toJson(),
      };
}
