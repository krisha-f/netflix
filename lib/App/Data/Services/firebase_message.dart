// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
//
// class NotificationService extends GetxService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   Future<NotificationService> init() async {
//     // Request permission (iOS/Android)
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('Permission granted');
//     }
//
//     // Local notifications for foreground
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initSettings =
//     InitializationSettings(android: androidSettings);
//     await _localNotifications.initialize(initSettings,
//         onDidReceiveNotificationResponse: (payload) {
//           print("Notification tapped: $payload");
//         });
//
//     // Foreground message listener
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//
//     return this;
//   }
//
//   void _showNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     if (notification != null) {
//       const AndroidNotificationDetails androidDetails =
//       AndroidNotificationDetails(
//         'channel_id',
//         'My Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//       );
//       const NotificationDetails details =
//       NotificationDetails(android: androidDetails);
//
//       await _localNotifications.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         details,
//       );
//     }
//   }
//
//   Future<String?> getToken() async {
//     return await _messaging.getToken();
//   }
// }