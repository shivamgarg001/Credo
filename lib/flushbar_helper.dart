// flushbar_helper.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/pages/settings/share.dart';
import 'package:credo/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Flushbar? flushbar;
// Function for showing success Flushbar (green color)
void showSuccessFlushbar(BuildContext context, String type) async{
  Flushbar(
    message: type,
    backgroundColor: Colors.green,  // Green color for success
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: Duration(milliseconds: 300),
  ).show(context);
}

void openWhatsApp(String phoneNumber, String message) async {
  final encodedMessage = Uri.encodeComponent(message);
  final whatsappUrl = "https://wa.me/$phoneNumber?text=$encodedMessage";

  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
    throw 'Could not open WhatsApp';
  }
}

// Function for showing error Flushbar (red color)
void showErrorFlushbar(BuildContext context, String type) {
  String? phoneNumber;
  final phoneMatch = RegExp(r'\{phone:([\d]+)\}').firstMatch(type.trim());
  if (phoneMatch != null && phoneMatch.groupCount >= 1) {
    phoneNumber = phoneMatch.group(1);
    type = type.replaceAll(phoneMatch.group(0)!, '').trim();
  }
  final containsInvite = type.contains("Please Invite");

  Flushbar(
    message: type,
    messageColor: Color.fromARGB(255, 0, 0, 0),
    backgroundColor: Color(0xFFFFF0F3),
    duration: Duration(seconds: 4),
    icon: Icon(Icons.error, color: Colors.red),
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: Duration(milliseconds: 300),
    mainButton: (containsInvite || phoneNumber != null)
    ? TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFF25D366), // WhatsApp green
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        onPressed: () {
          if (phoneNumber != null && phoneNumber.length >= 10) {
            final isValid = RegExp(r'^[1-9]\d{9,14}$').hasMatch(phoneNumber);
            if (!isValid) {
              showErrorFlushbar(context, "Invalid Phone Number");
              return;
            }

            final inviteMessage =
                "Hey! I am using Credo to manage my business transactions easily. You should try it too! Download now: https://bit.ly/credolabs";
            final encodedMessage = Uri.encodeComponent(inviteMessage);
            final url = "https://wa.me/$phoneNumber?text=$encodedMessage";
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Phone number not found or invalid')),
            );
          }
        },
        label: Text(
          "INVITE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    : null,
  ).show(context);
}
