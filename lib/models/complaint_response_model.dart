// To parse this JSON data, do
//
//     final complaintResponseModel = complaintResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'complaint_response_model.g.dart';

ComplaintResponseModel complaintResponseModelFromJson(String str) => ComplaintResponseModel.fromJson(json.decode(str));

String complaintResponseModelToJson(ComplaintResponseModel data) => json.encode(data.toJson());

@JsonSerializable()
class ComplaintResponseModel {
    @JsonKey(name: "complaints")
    List<Complaint>? complaints;

    ComplaintResponseModel({
        this.complaints,
    });

    factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) => _$ComplaintResponseModelFromJson(json);

    Map<String, dynamic> toJson() => _$ComplaintResponseModelToJson(this);
}

@JsonSerializable()
class Complaint {
    @JsonKey(name: "_id")
    String? id;
    @JsonKey(name: "fullName")
    String? fullName;
    @JsonKey(name: "mobileNumber")
    String? mobileNumber;
    @JsonKey(name: "tehsil")
    String? tehsil;
    @JsonKey(name: "gender")
    String? gender;
    @JsonKey(name: "address")
    String? address;
    @JsonKey(name: "yourMessage")
    String? yourMessage;
    @JsonKey(name: "isComplaintPending")
    bool? isComplaintPending;
    @JsonKey(name: "isComplaintRegistered")
    bool? isComplaintRegistered;
    @JsonKey(name: "date")
    DateTime? date;
    @JsonKey(name: "createdAt")
    DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    DateTime? updatedAt;

    Complaint({
        this.id,
        this.fullName,
        this.mobileNumber,
        this.tehsil,
        this.gender,
        this.address,
        this.yourMessage,
        this.isComplaintPending,
        this.isComplaintRegistered,
        this.date,
        this.createdAt,
        this.updatedAt,
    });

    factory Complaint.fromJson(Map<String, dynamic> json) => _$ComplaintFromJson(json);

    Map<String, dynamic> toJson() => _$ComplaintToJson(this);
}
