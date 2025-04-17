// //get token
// // ignore_for_file: avoid_print, unused_local_variable

// import 'dart:io';
// import 'package:e_comm/screens/user-panel/notification_screen.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   //send notificartion request
//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }

// //Fetch FCM Token
//   Future<String> getDeviceToken() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     String? token = await messaging.getToken();
//     print("token=> $token");
//     return token!;
//   }

//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();

//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }

// //
//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;

//       if (kDebugMode) {
//         print("notifications title:${notification!.title}");
//         print("notifications body:${notification.body}");
//         print('count:${android!.count}');
//         print('data:${message.data.toString()}');
//       }

//       if (Platform.isIOS) {
//         forgroundMessage();
//       }

//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//   }

//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(BuildContext context) async {
//     // // when app is terminated
//     // RemoteMessage? initialMessage =
//     //     await FirebaseMessaging.instance.getInitialMessage();

//     // if (initialMessage != null) {
//     //   handleMessage(context, initialMessage);
//     // }

//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });

//     // Handle terminated state
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null && message.data.isNotEmpty) {
//         handleMessage(context, message);
//       }
//     });
//   }

//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//       playSound: true,
//       // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: channel.sound
//             //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//             //  icon: largeIconPath
//             );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//         payload: 'my_data',
//       );
//     });
//   }

//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> handleMessage(
//     BuildContext context,
//     RemoteMessage message,
//   ) async {
//     print(
//         "Navigating to appointments screen. Hit here to handle the message. Message data: ${message.data}");

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => NotificationScreen(message: message),
//       ),
//     );

//     // if (message.data['screen'] == 'cart') {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => const CartScreen(),
//     //     ),
//     //   );
//     // } else {
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => NotificationScreen(message: message),
//     //     ),
//     //   );
//     // }
//   }
// }

//get token
// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import '../pages/login_signup/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //send notificartion request
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

//Fetch FCM Token
  Future<String> getDeviceToken(String phoneNo) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await messaging.getToken();
    if (token != null) {
      if (kDebugMode) {
        print("Device token: $token");
      }
      await saveTokenToFirestore(phoneNo, token);
    }
    return token!;
  }

  void listenForTokenRefresh(String phoneNo) {
    messaging.onTokenRefresh.listen((newToken) async {
      await saveTokenToFirestore(phoneNo, newToken);
      if (kDebugMode) {
        print("Token refreshed and updated in Firestore for $phoneNo: $newToken");
      }
    });
  }
  
  Future<String?> fetchTokenForPhoneNo(String phoneNo) async {
    // Retrieve the document for the given phone number
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('device_tokens')
        .doc(phoneNo)
        .get();

    if (doc.exists) {
      // Assuming the token is stored under the field 'token'
      return doc.get('token');
    } else {
      print("No token found for phone number: $phoneNo");
      return null;
    }
  }


  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      // handleMessage(context, message);
    });
  }

//
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        // forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

    // Handle terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
        handleMessage(context, message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
      // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'),
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: channel.sound
                // sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
        payload: 'my_data',
      );
    });
  }
  
  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> saveTokenToFirestore(String phoneNumber, String token) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      if (phoneNumber.isEmpty) {
          print("Error: Phone number is empty!");
          return;
      }

      await firestore.collection("device_tokens").doc(phoneNumber).set({
          "token": token,
          "updated_at": FieldValue.serverTimestamp(),
      });
  }


  Future<void> handleMessage(
    BuildContext context,
    RemoteMessage message,
  ) async {
    print(
        "Navigating to appointments screen. Hit here to handle the message. Message data: ${message.data}");

    WidgetsBinding.instance.addPostFrameCallback((_){
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
    });
  }
}