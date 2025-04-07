import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "dio_provider.g.dart";

@riverpod
Future<Dio> dio(Ref ref) async {
  return Dio(
    
  );
}