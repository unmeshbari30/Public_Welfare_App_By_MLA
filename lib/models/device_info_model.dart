// To parse this JSON data, do
//
//     final deviceInfoModel = deviceInfoModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'device_info_model.g.dart';

DeviceInfoModel deviceInfoModelFromJson(String str) => DeviceInfoModel.fromJson(json.decode(str));

String deviceInfoModelToJson(DeviceInfoModel data) => json.encode(data.toJson());

@JsonSerializable()
class DeviceInfoModel {
    @JsonKey(name: "platform")
    String? platform;
    @JsonKey(name: "version")
    String? version;
    @JsonKey(name: "deviceModel")
    String? deviceModel;
    @JsonKey(name: "manufacturer")
    String? manufacturer;
    @JsonKey(name: "deviceName")
    String? deviceName;
    @JsonKey(name: "connectionType")
    String? connectionType;
    @JsonKey(name: "wifiName")
    String? wifiName;
    @JsonKey(name: "wifiBSSID")
    String? wifiBssid;
    @JsonKey(name: "ipAddress")
    String? ipAddress;
    @JsonKey(name: "note")
    String? note;
    @JsonKey(name: "appVersion")
    String? appVersion;

    DeviceInfoModel({
        this.platform,
        this.version,
        this.deviceModel,
        this.manufacturer,
        this.deviceName,
        this.connectionType,
        this.wifiName,
        this.wifiBssid,
        this.ipAddress,
        this.note,
        this.appVersion
    });

    factory DeviceInfoModel.fromJson(Map<String, dynamic> json) => _$DeviceInfoModelFromJson(json);

    Map<String, dynamic> toJson() => _$DeviceInfoModelToJson(this);
}
