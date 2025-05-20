import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/app_imports.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/pages/login_signup/signup.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;
import 'package:credo/state/global_variables.dart'; // For making HTTP requests

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add a loading state
  bool _isLoading = false;
  Future<void> _showSuccessAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Lottie.asset('assets/animation/SuccessAnimation.json',
                width: 200, height: 200, repeat: false),
          ),
        );
      },
    );

    await Future.delayed(
        const Duration(milliseconds: 800)); // Wait for animation to complete
    if (mounted) {
      Navigator.of(context).pop();
    } // Close the dialog after delay
  }

  Future<void> _showFailureAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing manually
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Lottie.asset('assets/animation/FailAnimation.json',
                width: 200, height: 200, repeat: false),
          ),
        );
      },
    );

    await Future.delayed(
        const Duration(milliseconds: 800)); // Wait for animation to complete
    if (mounted) {
      Navigator.of(context).pop();
    } // Close the dialog after delay
  }

  void showNetworkErrorAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Lottie.asset('assets/animation/NetworkError.json'),
        ),
      ),
    );
  }

  // Login function
  Future<void> _loginUser() async {
    final String phoneNumber = _phoneController.text;
    final String password = _passwordController.text;

    if (phoneNumber.isEmpty || password.isEmpty) {
      // Show an error if any field is empty
      _showErrorMessage('Please fill all fields');
      return;
    }
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _isLoading = true);
    });

    // List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    // if (connectivityResult == ConnectivityResult.none) {
    //   showNetworkErrorAnimation();
    // }

    try {
      final response = await http.post(
        Uri.parse(
            'https://credolabs.xyz/client/v1/login/'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone_number': phoneNumber,
          'password': password,
        }),
      );
      print("here");

      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => _isLoading = false);
      });

      if (response.statusCode == 200) {
        final appState = Provider.of<AppState>(context, listen: false);
        appState.setPhoneNumber(phoneNumber); 
        appState.setPassword(password);

        try {
          final response = await http.get(
            Uri.parse(
                'https://credolabs.xyz/client/v1/get_id_from_phone_no/'),
            headers: {'Phone': phoneNumber},
          );
          print("here");

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data.containsKey('client_id')) {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.setClientId(data["client_id"].toString());
            } else {
              throw Exception('id not found in response');
            }
          } else if (response.statusCode == 400) {
            _showErrorMessage("Please enter Phone Number correctly!");
            throw Exception('Please enter Phone Number correctly!');
          } else {
            _showErrorMessage(
                "This Person is not on our App, Please Invite... 😊");
            throw Exception(
                'This Person is not on our App, Please Invite... 😊');
          }
        } catch (e) {
          print('Error in first API call: $e');
          return;
        }
        // Navigate to the next screen after successful login
        await _showSuccessAnimation();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BottomNavbar()), // Replace BottomNavbar with your next screen
          );
        }
      } else {
        _showErrorMessage(json.decode(response.body)['message']);
      }
    } catch (e) {
      _showErrorMessage('An error occurred. Please try again later.');
      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => _isLoading = false);
      });
      
    }
  }

  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    await Future.delayed(
        Duration(milliseconds: 1000)); // Use a noticeable delay

    if (mounted) {
      showErrorFlushbar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        AutoSizeText(
          S.of(context).welcome_back,
          style: TextStyle(
              fontFamily: 'SF-Pro', fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(
              hintText: "Phone Number",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Colors.green.withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.phone)),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.green.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            String phone = _phoneController.text;
            String password = _passwordController.text;
            if (phone.isNotEmpty && password.isNotEmpty && phone.length == 10) {
              _loginUser(); // Call the login API
            } else {
              // Show an error if fields are empty
              _showErrorMessage("Please enter both Phone Number and password");
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
          ),
          child: _isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/animation/Loading.json',
                    width: 50,
                    height: 50,
                    repeat: true,
                  ),
                )
              : AutoSizeText(
                  S.of(context).login,
                  style: TextStyle(fontFamily: 'SF-Pro', fontSize: 20),
                ),
        ),
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(S.of(context).dont_have_account),
        TextButton(
          onPressed: () {
            // Navigate to the signup page when the user clicks on "Sign Up"
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              });
            }
          },
          child: AutoSizeText(S.of(context).sign_up,
              style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
