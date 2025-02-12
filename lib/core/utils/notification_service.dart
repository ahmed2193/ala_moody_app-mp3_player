import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"),);

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse? notificationResponse) async {
        // if (route != null) {
        //   if (route == 'message') {
        //     Navigator.pushNamed(
        //       context,
        //       Routes.chatRoute,
        //     );
        //   } else if (route == 'project') {
        //     Navigator.pushNamed(
        //       context,
        //       Routes.homeRoute,
        //     );
        //   }
        // }
      },
    );
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "high_importance_channel", // id
        "high importance channel", // name

        importance: Importance.min,
        priority: Priority.high,
      ),);
      await _notificationsPlugin.show(
        id,
        message.data['title'],
        message.data['body'],
        notificationDetails,
        payload: message.data['type'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

// import 'package:altahadi/core/routes/app_routes.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // // Called when the app is in the background or terminated.
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   debugPrint("Handling a background message: ${message.messageId}");
// // }

// // class PushNotificationService {
// //   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
// //   final ValueNotifier<String?> _title = ValueNotifier(null);
// //   final ValueNotifier<String?> _body = ValueNotifier(null);

// //   ValueNotifier<String?> get getTitle => _title;
// //   ValueNotifier<String?> get getBody => _body;

// //   set setTitle(titleText) {
// //     _title.value = titleText;
// //   }

// //   set setBody(bodyText) {
// //     _body.value = bodyText;
// //   }

// //   Future initialise() async {
// //     // Requesting the permission from the user to show the notification
// //     NotificationSettings settings = await _fcm.requestPermission(
// //       alert: true,
// //       announcement: false,
// //       badge: true,
// //       carPlay: false,
// //       criticalAlert: false,
// //       provisional: false,
// //       sound: true,
// //     );

// //     // Continuosaly Listening to notification using [onMessage] stream
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //         // Updating the local values
// //         if (message.notification != null) {
// //           setTitle = message.notification!.title;
// //           setBody = message.notification!.body;
// //         }
// //       });
// //     } else if (settings.authorizationStatus ==
// //         AuthorizationStatus.provisional) {
// //       debugPrint('User granted provisional permission');
// //     } else {
// //       debugPrint('User declined or has not accepted permission');
// //     }
// //   }

// //   Future<void> setupInteractedMessage(context) async {
// //     // Handle any interaction when the app is in the background via a
// //     // Stream listener
// //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       _handleMessage(message, context);
// //     });
// //   }

// //   void _handleMessage(RemoteMessage message, BuildContext context) {
// //     // Updating local values with the values received from the Notification
// //     if (message.notification != null) {
// //       setTitle = message.notification!.title;
// //       setBody = message.notification!.body;
// //     }

// //     // Navigating to specific screen
// //     if (message.data['type'] == 'chat') {
// //       Navigator.pushNamed(context, Routes.editProfile);
// //     }
// //   }
// // }
// class FireMessaging {
//   static FirebaseMessaging messaging = FirebaseMessaging.instance;

//   static initialize(BuildContext context) async {
//     await messaging.requestPermission(sound: true);
//     FirebaseMessaging.onMessageOpenedApp;
//     FirebaseMessaging.onMessage;
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

//     FlutterLocalNotificationsPlugin localNotifications =
//         FlutterLocalNotificationsPlugin();

//     /// local notification appear when message sent when the app is in foreground
//     localNotifications.initialize(
//         const InitializationSettings(
//             android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//             iOS: IOSInitializationSettings()),
//         onSelectNotification: (String? payload) {
//       if (payload != null || payload!.isNotEmpty) {
//         Navigator.pushNamed(context, Routes.editProfile);
//       }
//     });

//     AndroidNotificationChannel channel = const AndroidNotificationChannel(
//         "id", "name",
//         importance: Importance.high);

//     await localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()!
//         .createNotificationChannel(channel);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       localNotifications.show(
//         message.notification.hashCode,
//         message.notification!.title,
//         message.notification!.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "id",
//             "name",
//             icon: "launch_background",
//             importance: Importance.high,
//           ),
//         ),
//         payload: message.data['route'],
//       );
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       /// called when i click on background notification
//       localNotifications.show(
//         message.notification.hashCode,
//         message.notification!.title,
//         message.notification!.body,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             "id",
//             "name",
//             icon: "launch_background",
//             importance: Importance.high,
//           ),
//         ),
//         payload: message.data['route'],
//       );
//     });
//   }
// }

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   /// called when background notification
// }

// Future<void> handelForgroundMessage(RemoteMessage message) async {
//   //  FirebaseMessaging.instance.getInitialMessage().then((message) {
//   //       if (message != null) {
//   //         final routeFromNotifiction = message.data['route'];
//   //         Navigator.of(context).pushNamed(routeFromNotifiction);
//   //       }
// }
