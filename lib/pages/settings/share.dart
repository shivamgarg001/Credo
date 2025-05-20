import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:credo/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';
import 'package:credo/widgets/custom_back_button.dart';
import 'package:credo/widgets/custom_text_button.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key});

  static const id = '/sharePage';

  void _shareInvite(BuildContext context) {
    const String message =
        "Hey! I am using Credo to manage my business transactions easily. You should try it too! Download now: https://bit.ly/credolabs";
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            children: [
              const CustomBackButton(title: 'Share'),
              const SizedBox(height: 45.0),
              Image.asset(
                'assets/images/share.png',
                width: 300,
              ),
              const SizedBox(height: 10.0),
               AutoSizeText(
                S.of(context).invite_new_person,
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              AutoSizeText(
                S.of(context).share_credo,
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontFamily: 'SF-Pro',
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 25.0),
              CustomButton(
                width: 220.0,
                icon: FontAwesomeIcons.whatsapp,
                title: 'Invite',
                onTap: () => _shareInvite(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
