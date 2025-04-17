
import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  final Map<String, dynamic> details;

  const ImageDetail({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Name: ${details['business_name'] ?? 'N/A'}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Name: ${details['name'] ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Address: ${details['address'] ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'GST: ${details['gst'] ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Phone Number: ${details['phone_number'] ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
