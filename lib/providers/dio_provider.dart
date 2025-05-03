// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part "dio_provider.g.dart";

// @riverpod
// Future<Dio> dio(Ref ref) async {
//   return Dio(
    
//   );
// }


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "dio_provider.g.dart";

@riverpod
Future<Dio> dio(Ref ref) async {
  final baseOptions = BaseOptions(
    // baseUrl: "http://192.168.31.202:3000",
    // baseUrl: "https://mla-app-c9r6.onrender.com/",
    baseUrl: "https://mla-app-vuc1.onrender.com",
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1),
    headers: {
      // 'Content-Type': 'application/json',
      // Add more headers if needed
    },
  );

  final dio = Dio(baseOptions);

  // dio.interceptors.add(
  //   InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       var prefs = await ref.read(sharedPreferencesProvider.future);
  //       var accessToken = prefs.getString(PrefrencesKeyEnum.accessToken.key);
  //       // Add an authorization token to every request
  //       options.headers["Authorization"] = "Bearer $accessToken";
  //       return handler.next(options);
  //     },
  //     onResponse: (response, handler) {
  //       print("Response: ${response.statusCode}");
  //       return handler.next(response);
  //     },
  //     onError: (DioException e, handler) {
  //       print("Error occurred: ${e.message}");
  //       return handler.next(e);
  //     },
  //   ),
  // );

  return dio;
}
