import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../model/data.dart';
import '../../pages/settings/account.dart';

class LedgerPageHeader extends StatelessWidget {
  const LedgerPageHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/images/play_store_512.png',
              width: 50.0,
            ),
            Consumer<DataModel>(
              builder: (context, value, child) {
                return value.activePlan == 'Premium'
                    ? Positioned(
                        top: -17,
                        child: Image.asset(
                          'assets/images/crown.png',
                          width: 23.0,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
        const SizedBox(width: 1.0),
        const AutoSizeText(
          'CREDO',
          style: TextStyle(
            fontFamily: 'SF-Pro', fontSize: 25.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AccountPage.id),
          child: Container(
            height: 35.0,
            width: 35.0,
            decoration: const BoxDecoration(
              color: kHighLightColor,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.account_balance_rounded),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
      ],
    );
  }
}
