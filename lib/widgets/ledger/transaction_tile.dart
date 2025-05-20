import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:credo/generated/l10n.dart';

import '../../constants.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.color,
    required this.name,
    required this.amount,
    required this.remarks,
    required this.type,
    required this.date,
  });

  final int color;
  final String name;
  final double amount;
  final String remarks;
  final String type;
  final String date;


@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          visualDensity: const VisualDensity(horizontal: -2),
          leading: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AutoSizeText(
                name[0].toUpperCase(), // Initial of the name
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'SF-Pro',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                minFontSize: 12,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AutoSizeText(
                  '₹$amount',
                  style: TextStyle(
                    color: (remarks == S.of(context).advance || amount <= 0) ? kPrimaryColor : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: AutoSizeText.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(text: amount.toString()),
                    ],
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5.0),
              AutoSizeText(
                remarks,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: 'SF-Pro',
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                minFontSize: 12,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        const Divider(
          color: kHighLightColor,
          height: 1,
        )
      ],
    ),
  );
}
}