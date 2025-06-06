
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';


@riverpod
Future<SharedPreferences> sharedPreferences (Ref ref) async{
  return  await SharedPreferences.getInstance();
}