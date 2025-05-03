// To parse this JSON data, do
//
//     final complaintPayloadModel = complaintPayloadModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'complaint_payload_model.g.dart';

ComplaintPayloadModel complaintPayloadModelFromJson(String str) => ComplaintPayloadModel.fromJson(json.decode(str));

String complaintPayloadModelToJson(ComplaintPayloadModel data) => json.encode(data.toJson());

@JsonSerializable()
class ComplaintPayloadModel {
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
    @JsonKey(name: "files")
    List<FileElement>? files;

    ComplaintPayloadModel({
        this.fullName,
        this.mobileNumber,
        this.tehsil,
        this.gender,
        this.address,
        this.yourMessage,
        this.files,
    });

    factory ComplaintPayloadModel.fromJson(Map<String, dynamic> json) => _$ComplaintPayloadModelFromJson(json);

    Map<String, dynamic> toJson() => _$ComplaintPayloadModelToJson(this);
}

@JsonSerializable()
class FileElement {
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "mimetype")
    String? mimetype;
    @JsonKey(name: "base64Data")
    String? base64Data;

    FileElement({
        this.name,
        this.mimetype,
        this.base64Data,
    });

    factory FileElement.fromJson(Map<String, dynamic> json) => _$FileElementFromJson(json);

    Map<String, dynamic> toJson() => _$FileElementToJson(this);
}
