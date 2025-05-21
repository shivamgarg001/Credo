import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsPage extends StatelessWidget {
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms and Conditions of Use",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Effective Date: 21st May 2025\n\n",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text:
                        "Welcome to Credo, a mobile application (“App”) developed and operated by Shivam Garg, a sole proprietor (hereafter “Service Provider”, “we”, or “us”). These Terms and Conditions (“Terms”) govern your access to and use of the App and the services provided through it (collectively, the “Services”).\n\n"
                        "By downloading, registering, or using the App, you agree to these Terms. If you do not agree, please refrain from using the App.\n\n",
                  ),
                  TextSpan(
                    text: "Full Link: ",
                  ),
                  TextSpan(
                    text: "https://sites.google.com/view/credo-terms-and-conditions/home\n\n",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL("https://sites.google.com/view/credo-terms-and-conditions/home");
                      },
                  ),
                  TextSpan(
                    text: "1. Eligibility\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- You must be at least 18 years old.\n- You must reside in India.\n- You must have legal capacity to accept these Terms.\n\n",
                  ),
                  TextSpan(
                    text: "2. Services Offered\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Create and manage digital ledgers\n- Store and retrieve invoice details\n- Upload files via camera/gallery\n- Manage customer/supplier records\n- No payment gateway or lending features are provided\n\n",
                  ),
                  TextSpan(
                    text: "3. User Account and Onboarding\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Users must register with valid name, phone, email, and GST number\n- Passwords are stored using secure hashing\n- Users are responsible for account security\n\n",
                  ),
                  TextSpan(
                    text: "4. Permissions and Device Access\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Camera: For scanning/uploading documents\n- Gallery: For file selection\n- Contacts: For linking customers/suppliers\n\n",
                  ),
                  TextSpan(
                    text: "5. Data Storage and Security\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Data is stored on AWS India and MongoDB Atlas\n- We follow best practices including encryption and access control\n\n",
                  ),
                  TextSpan(
                    text: "6. Consent and Communication\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Users agree to receive operational emails and push notifications via Firebase\n- Push notifications can be turned off via phone settings\n\n",
                  ),
                  TextSpan(
                    text: "7. Restrictions and User Obligations\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Do not engage in illegal, fraudulent, or abusive behavior\n- Do not upload harmful or malicious content\n- Do not use the app to harass, impersonate, or defame others\n\n",
                  ),
                  TextSpan(
                    text: "8. Intellectual Property\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- All logos, content, and code belong to the Service Provider\n- You may not reproduce or redistribute without permission\n\n",
                  ),
                  TextSpan(
                    text: "9. Termination\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- We may terminate access for violating Terms\n- You may also delete your account in-app\n- Termination revokes access to data and features\n\n",
                  ),
                  TextSpan(
                    text: "10. Disclaimer and Limitation of Liability\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- The App is provided “as is” without warranties\n- We are not liable for data loss, downtime, or misuse\n- Your use is at your own risk\n\n",
                  ),
                  TextSpan(
                    text: "11. Indemnity\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- You agree to defend and indemnify us from claims arising due to your misuse or violation of these Terms\n\n",
                  ),
                  TextSpan(
                    text: "12. Changes to Terms\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- We may update Terms anytime\n- Continued use constitutes agreement with updated Terms\n\n",
                  ),
                  TextSpan(
                    text: "13. Governing Law and Jurisdiction\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- Governed by the laws of India\n- Jurisdiction: Courts in New Delhi, India\n\n",
                  ),
                  TextSpan(
                    text: "14. Contact Information\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "- For any concerns, email:\n  - labs.credo@gmail.com\n  - shivamg2701@gmail.com\n",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
