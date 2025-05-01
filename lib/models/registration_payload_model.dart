// To parse this JSON data, do
//
//     final registrationPayloadModel = registrationPayloadModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'registration_payload_model.g.dart';

RegistrationPayloadModel registrationPayloadModelFromJson(String str) => RegistrationPayloadModel.fromJson(json.decode(str));

String registrationPayloadModelToJson(RegistrationPayloadModel data) => json.encode(data.toJson());

@JsonSerializable()
class RegistrationPayloadModel {
    @JsonKey(name: "username")
    String? username;
    @JsonKey(name: "firstName")
    String? firstName;
    @JsonKey(name: "lastName")
    String? lastName;
    @JsonKey(name: "gender")
    String? gender;
    @JsonKey(name: "age")
    int? age;
    @JsonKey(name: "mobileNumber")
    String? mobileNumber;
    @JsonKey(name: "whatsappNumber")
    String? whatsappNumber;
    @JsonKey(name: "bloodGroup")
    String? bloodGroup;
    @JsonKey(name: "mailId")
    String? mailId;
    @JsonKey(name: "taluka")
    String? taluka;
    @JsonKey(name: "password")
    String? password;

    RegistrationPayloadModel({
        this.username,
        this.firstName,
        this.lastName,
        this.gender,
        this.age,
        this.mobileNumber,
        this.whatsappNumber,
        this.bloodGroup,
        this.mailId,
        this.taluka,
        this.password,
    });

    factory RegistrationPayloadModel.fromJson(Map<String, dynamic> json) => _$RegistrationPayloadModelFromJson(json);

    Map<String, dynamic> toJson() => _$RegistrationPayloadModelToJson(this);
}
