// To parse this JSON data, do
//
//     final registrationResponseModel = registrationResponseModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'registration_response_model.g.dart';

RegistrationResponseModel registrationResponseModelFromJson(String str) => RegistrationResponseModel.fromJson(json.decode(str));

String registrationResponseModelToJson(RegistrationResponseModel data) => json.encode(data.toJson());

@JsonSerializable()
class RegistrationResponseModel {
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "username")
    String? username;
    @JsonKey(name: "firstName")
    String? firstName;
    @JsonKey(name: "lastName")
    String? lastName;
    @JsonKey(name: "isRegistered")
    bool? isRegistered;

    RegistrationResponseModel({
        this.message,
        this.username,
        this.firstName,
        this.lastName,
        this.isRegistered
    });

    factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) => _$RegistrationResponseModelFromJson(json);

    Map<String, dynamic> toJson() => _$RegistrationResponseModelToJson(this);
}
