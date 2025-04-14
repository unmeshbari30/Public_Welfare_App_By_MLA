import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_app/models/login_payload_model.dart';
import 'package:test_app/providers/dio_provider.dart';

part 'repository.g.dart';

class Repository {
  final Dio dio;

  Future<LoginPayloadModel?> loginUser({
  required LoginPayloadModel loginPayload,
}) async {

  try {

    var details = jsonEncode(loginPayload.toJson());
    final response = await dio.post(
      "/api/v1/signin",
      data: details
    );

    if (response.statusCode == 200) {
      final data = response.data;

      final res   = LoginPayloadModel.fromJson(data);
      return res;
    } else {
      print("Server responded with status: ${response.statusCode}");
    }
  } on DioException catch (e) {
    print("Dio error: ${e.message}");
    if (e.response != null) {
      print("Response data: ${e.response?.data}");
      print("Status code: ${e.response?.statusCode}");
    }
  } catch (e) {
    print("Unexpected error: $e");
  }

  return null;
}

  Repository({
    required this.dio,
  });
}

@riverpod
Future<Repository> repository(Ref ref) async {
  return Repository(dio: await ref.watch(dioProvider.future));
}
