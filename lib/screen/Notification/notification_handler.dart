import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_app/Notification/notification_service.dart';

class FCMHandler extends StatefulWidget {
  final Widget child;

  const FCMHandler({super.key, required this.child});

  @override
  State<FCMHandler> createState() => _FCMHandlerState();
}

class _FCMHandlerState extends State<FCMHandler> {
  @override
  void initState() {
    super.initState();

    // ✅ Initialize local notifications
    NotificationService.initialize(context);

    // 🔑 Get FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print('🟢 FCM Token: $token');
    });

    // 📥 Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 Foreground message received!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Notification title: ${message.notification!.title}');
        print('Notification body: ${message.notification!.body}');

        // ✅ Show notification in status bar
        NotificationService.display(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
