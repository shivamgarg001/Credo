import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  // Function to launch a URL
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy for Credo",
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
                        "This Privacy Policy applies to the mobile application Credo (the “Application”) developed and operated by Shivam Garg (the “Service Provider”) and made available as a free service. The Application is intended to be used “AS IS.”\n\n"
                        "By using Credo, you agree to the practices described in this policy. If you do not agree, please discontinue use of the Application.\n\n",
                  ),
                  TextSpan(
                    text: "Privacy Policy Link: ",
                  ),
                  TextSpan(
                    text: "https://sites.google.com/view/credo-privacy-policy/home\n\n",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL("https://sites.google.com/view/credo-privacy-policy/home");
                      },
                  ),
                  TextSpan(
                    text: "1. Information We Collect\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\na) User-Provided Information:\n- Name\n- Phone number\n- Email address\n- Residential or Business Address\n- GST number\n- Passwords (securely hashed)\n\n"
                        "b) Automatically Collected Information:\n- Device IP address\n- Operating system\n- Device type\n- Pages visited and duration\n- Firebase Crashlytics logs\n\n"
                        "Note: We do not collect GPS location, media content, SMS, or call logs.\n\n",
                  ),
                  TextSpan(
                    text: "2. Device Permissions Used\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n- Camera: For document capture\n- Gallery: For image upload\n- Contacts: For customer/supplier association\n\n",
                  ),
                  TextSpan(
                    text: "3. How We Use Your Data\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n- To create and manage your account\n- To store and retrieve ledger and invoice data\n- To send push notifications (via Firebase)\n- For in-app functionality and technical performance\n\n",
                  ),
                  TextSpan(
                    text: "4. Data Storage and Security\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n- AWS India: App backend data\n- MongoDB Atlas: Invoice and ledger data\n- All credentials are stored securely using encryption and best practices\n\n",
                  ),
                  TextSpan(
                    text: "5. Third-Party Services\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nWe use:\n- Google Play Services\n- Firebase Analytics\n- Firebase Crashlytics\n\nThese services may collect aggregated, anonymized data.\n\n",
                  ),
                  TextSpan(
                    text: "6. Data Retention and Deletion\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n- Data is retained while your account is active and deleted upon account removal\n- You can delete your data directly in the app\n- Or email us at shivamg2701@gmail.com for removal requests\n\n",
                  ),
                  TextSpan(
                    text: "7. Security Measures\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nWe implement security measures including encryption, hashing, and secured cloud infrastructure. While we strive for complete safety, no method of transmission over the Internet is 100% secure.\n\n",
                  ),
                  TextSpan(
                    text: "8. Children’s Privacy\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nCredo is not intended for children under 13. We do not knowingly collect data from children. If we discover such data, we will delete it immediately. Parents may contact us to take necessary action.\n\n",
                  ),
                  TextSpan(
                    text: "9. Changes to the Privacy Policy\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nThis Privacy Policy may be updated periodically. All updates will be notified via app update or in-app message.\n\n",
                  ),
                  TextSpan(
                    text: "10. Governing Law\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nThis Privacy Policy is governed by the laws of India. Any disputes shall be subject to the jurisdiction of New Delhi, India.\n\n",
                  ),
                  TextSpan(
                    text: "11. Contact Us\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nIf you have any questions or feedback, please contact:\n- labs.credo@gmail.com\n- shivamg2701@gmail.com\n",
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
