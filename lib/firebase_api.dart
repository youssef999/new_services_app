import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/features/Tasks/views/user_tasks_view.dart';
import 'package:freelancerApp/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    print("navigatinggg");
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) {
      return const UserTasksView();
    }));
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle the received message here
  print("Title: ${message.notification?.title}");
  print("body: ${message.notification?.body}");
  print("payload: ${message.data}");
}
