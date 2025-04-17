// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// // Import dart_jsonwebtoken library
// import 'package:credo/api/get_server_key.dart';
// import 'package:credo/api/notificationService.dart';
// import 'package:provider/provider.dart';

// import './state/global_variables.dart';


// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Initialize Firebase and request notification permission
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       _initializeFirebase();
//     });
//   }

//   // Method to initialize Firebase and call other necessary Firebase API functions
//   void _initializeFirebase() async {
//     final appState = Provider.of<AppState>(context, listen: false);
//     print("phone number here is ${appState.phoneNumber.toString()}");
//     // Initialize Firebase first
//     NotificationService().firebaseInit(context);

//     // Request notification permission
//     NotificationService().requestNotificationPermission();

//     // Set up interactive message handling
//     NotificationService().setupInteractMessage(context);

//     // Get the device token and print it
//     NotificationService().getDeviceToken(appState.phoneNumber.toString()).then((value) {
//       print("DEVICE TOKEN: $value");

//       // Check and refresh token if needed
//       NotificationService().listenForTokenRefresh(appState.phoneNumber.toString());
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: AutoSizeText("Notification Screen"),
//       ),
//       body: Center(
//         child: TextButton(
//           onPressed: () async {
//             GetServerKey getServerKey = GetServerKey() ;
//             String serverkey = await getServerKey.getServerKeyToken();
//             print(serverkey.toString());
//           },
//           child: AutoSizeText("Press to send message"),
//         ),
//       ),
//     );
//   }
// }
