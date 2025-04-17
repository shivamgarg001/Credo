import 'package:flutter/material.dart';
import 'package:credo/bottom_navbar.dart';
import 'package:credo/pages/login_signup/login.dart';
import 'package:credo/state/global_variables.dart';
import 'package:provider/provider.dart';
// Import dart_jsonwebtoken library
import 'package:credo/api/notificationService.dart';

import './app_imports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int _currentAnimationIndex = 0;
  final List<String> _animations = [
    'assets/images/play_store_512.png', // Add more animations if needed
  ];

  void _initializeFirebase() async {
    // final appState = Provider.of<AppState>(context, listen: false);
    // print("phone number here is ${appState.phoneNumber.toString()}");
    // // Initialize Firebase first
    // NotificationService().firebaseInit(context);

    // // Request notification permission
    // NotificationService().requestNotificationPermission();

    // // Set up interactive message handling
    // NotificationService().setupInteractMessage(context);

    // // Get the device token and print it
    // NotificationService().getDeviceToken(appState.phoneNumber.toString()).then((value) {
    //   print("DEVICE TOKEN: $value");

    //   // Check and refresh token if needed
    //   NotificationService().listenForTokenRefresh(appState.phoneNumber.toString());
    // });
  }
  // This function will check the login status
  Future<bool> _checkLoginStatus(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final clientId = appState.clientId;
    bool isLoggedIn = await appState.isUserLoggedIn();
    if (clientId != null && clientId.isNotEmpty && isLoggedIn) {
      // If the clientId is not null or empty or logged in or not logout recently, consider the user as logged in
      return true;
    }
    return false; // Otherwise, the user is not logged in
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   _initializeFirebase();
    // });

    // Show the animation and after 100 milliseconds check the login status
    // Future.delayed(Duration(milliseconds: 100), () {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // _initializeFirebase(); // Commented out for now

        bool isLoggedIn = await _checkLoginStatus(context);
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isLoggedIn ? const BottomNavbar() : const LoginPage(),
          ),
        );
      });
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Optional, background color
      // body: Center(
      //   child: Image.asset(
      //       _animations[_currentAnimationIndex]), // Show splash animation
      // ),
    );
  }
}
