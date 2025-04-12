
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_app/providers/dio_provider.dart';

part 'repository.g.dart';

class Repository {

final Dio dio;





Repository({
  required this.dio,
});

}

@riverpod
Future<Repository>  repository (Ref ref) async{

  return Repository(dio: await ref.watch(dioProvider.future));  

}