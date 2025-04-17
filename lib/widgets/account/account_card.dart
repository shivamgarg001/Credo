import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:credo/generated/l10n.dart';

import '../../constants.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({
    super.key,
    required this.accountType,
    required this.paymentType,
    required this.amount,
    required this.icon,
  });

  final IconData icon;
  final String accountType;
  final String paymentType;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: kHighLightColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: kPrimaryColor,
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
               AutoSizeText(S.of(context).net_balance,                               
               overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                '$accountType Khata',
                style: const TextStyle(
                  color: kSecondaryColor,
                  fontFamily: 'SF-Pro', fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                '₹$amount',
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'SF-Pro', fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Spacer(),
              AutoSizeText(paymentType == 'R' ? S.of(context).you_get : S.of(context).you_give),
            ],
          )
        ],
      ),
    );
  }
}
