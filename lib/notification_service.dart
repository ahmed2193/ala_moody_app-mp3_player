import 'dart:convert';
import 'dart:developer';

import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/notification/presentation/screen/notification_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging? messaging;
  late NotificationDetails notificationDetails;
  final DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  final AndroidNotificationDetails androidDetails =
      const AndroidNotificationDetails(
    'high_importance',
    'High importance notifications',
    icon: '@mipmap/ic_launcher',
    importance: Importance.max,
    priority: Priority.high,
  );

  Future<void> initializeLocalNotifications(BuildContext context) async {
    // await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    await notificationPermission();
    await initMessaging(context);
  }

  Future<void> notificationPermission() async {
    await messaging!.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await messaging!.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
  }

  Future<void> initMessaging(BuildContext context) async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'high_importance',
      'High importance notifications',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final Map<String, dynamic> messageData =
              json.decode(response.payload!);
          _handleNotificationTap(context, RemoteMessage(data: messageData));
        }
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;

      printColored(json.encode(message.data));
      if (notification != null) {
        await _notificationsPlugin.show(
          generateNotificationId(),
          notification.title,
          notification.body,
          notificationDetails,
          payload: json.encode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Constants.customPrint(message.senderId.toString());
      // Constants.customPrint(message.notification.toString());
      _handleNotificationTap(context, message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(context, message);
      }
    });
  }

  Future<void> showNotification(String title, String body) async {
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance',
      'High importance notifications',
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(0, title, body, details);
  }
   void _handleNotificationTap(
      BuildContext context, RemoteMessage message,) async {
    final String? type = message.data['type'];
    printColored(message.data.toString());
    printColored(message.data.toString());
    log(message.data['receiverId'].toString());
 pushNavigate(context, const NotificationScreen());
   
    await _notificationsPlugin.cancelAll();

    // await _flutterLocalNotificationsPlugin.cancel(message.hashCode);
  }
  // void handleIncomingMessages(BuildContext context) {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     printColored(
  //         'Received message: ${message.notification?.title}, ${message.notification?.body}');
  //    printColored('senderId message: ${message.data['senderId']}');
  //     // _handleNotificationTap(context, message);
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //    printColored(
  //         'Message opened: ${message.notification?.title}, ${message.notification?.body}');
  //     _handleNotificationTap(context, message);
  //   });
  // }

}
 
  int generateNotificationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    // Reduce the range to fit within a 32-bit integer
    return timestamp % 2147483647
        ; // 2147483647 is the max value for a 32-bit signed integer
  }
