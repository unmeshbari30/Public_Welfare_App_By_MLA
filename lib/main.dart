import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/screen/Login_Screens/login_screen.dart';
import 'package:test_app/screen/home_screen.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Future.delayed(Duration(seconds: 2)); 
  // FlutterNativeSplash.remove();
  AuthenticationController mainController = AuthenticationController();
  bool isLoggedIn = await mainController.checkIsLogin();
  // var temp = ref.read(homeControllerProvider.notifier).checkIsLogin();
  runApp( ProviderScope(child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;
   const MyApp({super.key,required this.isLoggedIn});

    // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home:  isLoggedIn ?  LocalPinScreen() : LoginScreen(),
      home:  isLoggedIn ?  HomeScreen() : LoginScreen(),
    );
  }
}
