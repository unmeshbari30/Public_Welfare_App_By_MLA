// To parse this JSON data, do
//
//     final loginPayloadModel = loginPayloadModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

import 'package:test_app/models/device_info_model.dart';

part 'login_payload_model.g.dart';

LoginPayloadModel loginPayloadModelFromJson(String str) => LoginPayloadModel.fromJson(json.decode(str));

String loginPayloadModelToJson(LoginPayloadModel data) => json.encode(data.toJson());

@JsonSerializable()
class LoginPayloadModel {
    @JsonKey(name: "username")
    String? userName;
    @JsonKey(name: "password")
    String? password;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "accessToken")
    String? accessToken;
    @JsonKey(name:"refreshToken")
    String? refreshToken;
    @JsonKey(name: "deviceInfo")
    DeviceInfoModel? deviceInfo;

    LoginPayloadModel({
        this.userName,
        this.password,
        this.deviceInfo,
        this.accessToken,
        this.refreshToken
    });

    factory LoginPayloadModel.fromJson(Map<String, dynamic> json) => _$LoginPayloadModelFromJson(json);

    Map<String, dynamic> toJson() => _$LoginPayloadModelToJson(this);
}