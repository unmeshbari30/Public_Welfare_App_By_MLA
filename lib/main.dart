import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/controllers/authentication_controller.dart';
import 'package:test_app/screen/Login_Screens/login_screen.dart';
import 'package:test_app/screen/home_screen.dart';
import 'package:test_app/screen/Notification/notification_handler.dart';

// OPTIONAL: Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle the background message (e.g., show notification, update DB)
  print('Handling a background message: ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

   // ✅ Initialize Firebase
  await Firebase.initializeApp();

  // ✅ Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Optional: Request permission (important for iOS, useful for Android 13+)
  await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
  );

  AuthenticationController mainController = AuthenticationController();
  bool isLoggedIn = await mainController.checkIsLogin();
  runApp( ProviderScope(child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;
   const MyApp({super.key,required this.isLoggedIn});

    // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return FCMHandler(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home:  isLoggedIn ?  LocalPinScreen() : LoginScreen(),
        home:  isLoggedIn ?  HomeScreen() : LoginScreen(),
      ),
    );
  }
}
