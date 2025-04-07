import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:test_app/screen/Login_Screens/local_pin_screen.dart';
import 'package:test_app/screen/Login_Screens/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  HomeController mainController = HomeController();
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  isLoggedIn ? LoginScreen() : LocalPinScreen(),
    );
  }
}
