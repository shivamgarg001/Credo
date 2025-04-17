import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credo/model/data.dart';
import 'package:credo/widgets/custom_text_button.dart';

import '../../constants.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.color,
    this.headerIcon,
    required this.title,
    required this.price,
    required this.bulletIcon,
    required this.bulletPoints,
    required this.isActive,
  });

  final Color color;
  final IconData? headerIcon;
  final String title;
  final String price;
  final Widget bulletIcon;
  final List<String> bulletPoints;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        color: kHighLightColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const SizedBox(width: 10.0),
                headerIcon != null
                    ? Icon(headerIcon, color: Colors.white)
                    : const SizedBox.shrink(),
                const SizedBox(width: 10.0),
                AutoSizeText(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'SF-Pro', fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                AutoSizeText(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SF-Pro', fontSize: 18.0,
                    fontWeight:
                        price == 'FREE' ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 15.0)
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: [
                for (final bullet in bulletPoints)
                  Row(
                    children: [
                      bulletIcon,
                      const SizedBox(width: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: AutoSizeText(
                          bullet,
                          style: const TextStyle(
                            fontFamily: 'SF-Pro', fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 10.0),
                CustomButton(
                  title: isActive ? 'Current Plan' : 'Select Plan',
                  color: color,
                  height: 35.0,
                  onTap: !isActive
                      ? () => context.read<DataModel>().updatePlan()
                      : () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
