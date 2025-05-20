import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/bottom_navbar.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/pages/login_signup/login.dart';
import 'package:credo/state/global_variables.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
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

  Future<void> _signup() async {
    final String clientName = _usernameController.text;
    final String phoneNumber = _phoneController.text;
    final String password = _passwordController.text;

    if (clientName.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ) {
      _showErrorMessage('Please fill all fields');
      return;
    }

    Future.delayed(Duration.zero, () {
      if (mounted) setState(() => _isLoading = true);
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://credolabs.xyz/client/v1/signup/'), // Replace with your signup endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'client_name': clientName,
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => _isLoading = false);
      });

      if (response.statusCode == 200) {
        try {
          final response = await http.get(
            Uri.parse(
                'https://credolabs.xyz/client/v1/get_id_from_phone_no/'),
            headers: {'Phone': phoneNumber},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data.containsKey('client_id')) {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.setClientName(clientName);
              appState.setPhoneNumber(phoneNumber);
              appState.setPassword(password);
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
        await _showSuccessAnimation();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BottomNavbar()), // Navigate to Login after successful signup
          );
        }
      } else {
        _showErrorMessage(json.decode(response.body)['message']);
      }
    } catch (e) {
      print(e);
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 60.0),
                    AutoSizeText(
                      S.of(context).sign_up,
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    // Username field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          fillColor: Colors.green.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.person)),
                    ),

                    AutoSizeText(
                      S.of(context).name_visible_to_all,
                      style: TextStyle(
                        fontFamily: 'SF-Pro', fontSize: 12,
                        color: Colors
                            .green, // Red color to make the warning more noticeable
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Phone Number field
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
                    const SizedBox(height: 20),

                    // Password field
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
                    const SizedBox(height: 20),
                  ],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
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
                              S.of(context).sign_up,
                              style: TextStyle(
                                  fontFamily: 'SF-Pro',
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(S.of(context).already_have_account),
                    TextButton(
                        onPressed: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          });
                        },
                        child: AutoSizeText(
                          S.of(context).login,
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
