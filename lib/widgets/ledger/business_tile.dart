import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class BusinessTile extends StatelessWidget {
  const BusinessTile({
    super.key,
    required this.imagePath,
    required this.userName,
    required this.businessName,
    this.isActive,
  });

  final String imagePath;
  final String userName;
  final String businessName;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: isActive == true
          ? BoxDecoration(
              color: kHighLightColor,
              borderRadius: BorderRadius.circular(12.0),
            )
          : null,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                userName,
                style: const TextStyle(
                  fontFamily: 'SF-Pro', fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                businessName,
                style: const TextStyle(
                  color: kSecondaryAccent,
                  fontFamily: 'SF-Pro', fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          const Spacer(),
          isActive == true
              ? const Icon(
                  Icons.edit,
                  size: 22.0,
                  color: kPrimaryColor,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
