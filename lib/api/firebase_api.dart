// import 'dart:io';
// import 'dart:math';

// import 'package:app_settings/app_settings.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:credo/opening_screen.dart';

// class FirebaseApi {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   void initLocalNotifications(BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
//     var iosInitializationSettings = const DarwinInitializationSettings();

//     var initializationSettings = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveBackgroundNotificationResponse: (payload){
//         handleMessage(context, message);
//       }
//     );
//   }
  
//   void firebaseInit(BuildContext context){
//     FirebaseMessaging.onMessage.listen((message){
//       if(kDebugMode){
//         print(message.notification?.title.toString());
//         print(message.notification?.body.toString());
//       }
//       if(Platform.isAndroid){
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//       else{
//         showNotification(message);
//       }
    
//     });
//   }

//   Future<void> showNotification(RemoteMessage message) async{

//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(100000).toString(), 
//       "High Importance Notification",
//       importance: Importance.max
//     );

//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: "Your channel Description",
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker'
//     );

//     DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails
//     );



//     Future.delayed(Duration.zero,
//       (){
//         _flutterLocalNotificationsPlugin.show(
//           0, 
//           message.notification?.title.toString(), 
//           message.notification?.body.toString(), 
//           notificationDetails
//         );
//       });


//   }
//   void requestNotificationPermission() async {
//     // Request permission for iOS
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       announcement: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true
//     );
//     if(settings.authorizationStatus == AuthorizationStatus.authorized){
//       print("User Granted Permission");
//     }
//     else if(settings.authorizationStatus == AuthorizationStatus.provisional){
//       print("User Granted Permission Provisionally");
//     }
//     else{
//       AppSettings.openAppSettings(type: AppSettingsType.notification);
//       print("User Denied Permission");
//     }
//   }

//   Future<String> getDeviceToken() async{
//     final fcmToken = await _firebaseMessaging.getToken();
//     if (fcmToken != null) {
//       print('FCM Token: $fcmToken');
//     } else {
//       print('Failed to retrieve FCM token');
//     }
//     return fcmToken.toString();
//   }

//   void isRefreshToken () async{
//     _firebaseMessaging.onTokenRefresh.listen((event){
//       event.toString();
//       print("refresh");
//     });
//   }
  
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if(message.data['type']=='hello'){
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SplashScreen()), // Go to BottomNavbar if logged in
//       );
//       print("hello i am in handle message");

//     }
//   }

//   Future<void> setupInteractMessage(BuildContext context) async{
//     RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

//     if(initialMessage!=null){
//       handleMessage(context, initialMessage);
//     }

//     FirebaseMessaging.onMessageOpenedApp.listen((event){
//       handleMessage(context, event);
//     });
//   }
// }
