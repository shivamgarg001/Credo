import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';
import '../../model/data.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/settings/setting_tile.dart';
import 'package:http/http.dart' as http;
import '../login_signup/login.dart';
import '../login_signup/signup.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  static const id = '/securityPage';

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  Future<void> _signOut(BuildContext context, AppState appState) async {
    final bool confirm = await _showConfirmationDialog(
      context, S.of(context).are_you_sure_sign_out);
    if (confirm) {
      await appState.clearSharedPreferences(); 
      await _showSuccessAnimation();
      

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Go to BottomNavbar if logged in
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context, AppState appState) async {
    final bool confirm = await _showConfirmationDialog(
      context, S.of(context).are_you_sure_delete_account);
    if (confirm) {
      final response = await http.delete(Uri.parse('https://credolabs.xyz/client/v1/deleteclient/'), headers: {'Client-ID':appState.clientId.toString()});
      if (response.statusCode == 200) {
        await appState.clearSharedPreferences(); // Clear all user data
        showSuccessFlushbar(context, S.of(context).sorry_to_see_you_go);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()), // Go to BottomNavbar if logged in
        );
      } else {
        _showErrorMessage(S.of(context).account_deletion_failed);
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title:  AutoSizeText(S.of(context).confirmation,                               
            overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
            content: AutoSizeText(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child:  AutoSizeText(S.of(context).cancel,                               
                overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child:  AutoSizeText(S.of(context).confirm,                               
                overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _authenticateFingerprint(BuildContext context, DataModel value) async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isAuthenticated = false;
    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: S.of(context).authenticate_for_fingerprint_unlock,
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: AutoSizeText(S.of(context).fingerprint_authentication_failed,                               
         overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
)),
      );
    }
    if (isAuthenticated) {
      value.toggleSwitch(SwitchType.fingerPrint);
    }
  }

  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    await Future.delayed(const Duration(milliseconds: 1000)); // Noticeable delay
    showErrorFlushbar(context, message);
  }

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

    await Future.delayed(const Duration(milliseconds: 800)); // Wait for animation to complete
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showFailureAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
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

    await Future.delayed(const Duration(milliseconds: 800)); // Wait for animation to complete
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Consumer2<DataModel, AppState>(
            builder: (context, value, appState, child) {
              return Column(
                children: [
                  const CustomBackButton(title: 'Security'),
                  // SettingTile(
                  //   icon: Icons.fingerprint,
                  //   title: S.of(context).fingerprint_unlock,
                  //   trailing: CustomSwitch(
                  //     onChanged: (p0) => _authenticateFingerprint(context, value),
                  //     value: value.isFingerprintEnabled,
                  //   ),
                  // ),
                  SettingTile(
                    onTap: () => _signOut(context, appState),
                    icon: Icons.power_settings_new,
                    title: S.of(context).sign_out,
                  ),
                  SettingTile(
                    onTap: () => _deleteAccount(context, appState),
                    icon: Icons.delete_forever,
                    title: S.of(context).delete_account_forever,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}