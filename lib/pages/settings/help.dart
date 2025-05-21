import 'package:credo/pages/settings/terms_and_conditions.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/settings/setting_tile.dart';
import 'privacy_policy.dart'; 
import 'terms_and_conditions.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const id = '/helpPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            children: [
              const CustomBackButton(title: 'Help'),
              // const SettingTile(
              //   icon: Icons.help,
              //   title: 'How to use credo?',
              // ),
              // const SettingTile(
              //   icon: Icons.info,
              //   title: 'About credo',
              // ),
              SettingTile(
                icon: Icons.lock,
                title: 'Privacy Policy & Security',
                onTap: () => _navigateToPrivacyPolicy(context), // Wrap it in a closure
              ),
              SettingTile(
                icon: Icons.gavel,
                title: 'Terms & Conditions',
                onTap: () => _navigateToTermsAndConditions(context), // Wrap it in a closure
              ),
              // const Spacer(),
              // CustomButton(
              //   icon: Icons.call,
              //   title: 'Call Customer Care',
              //   onTap: () {},
              // ),
              // const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  // Method to navigate to the Privacy Policy page
  static void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
    );
  }

  // Method to navigate to the Terms and Conditions page
  static void _navigateToTermsAndConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
    );
  }
}
