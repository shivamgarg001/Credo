import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credo/state/global_variables.dart';

import '../../constants.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/account/account_card.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  static const id = '/accountPage';

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    double totalCustomerAmount = appState.totalCustomerAmount;
    double totalSupplierAmount = appState.totalSupplierAmount;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            children: [
              const CustomBackButton(title: 'Account'),
               AccountCard(
                icon: Icons.book,
                accountType: 'Customer',
                paymentType: 'R',
                amount: totalCustomerAmount,
              ),
               AccountCard(
                icon: Icons.local_shipping_sharp,
                accountType: 'Supplier',
                paymentType: 'G',
                amount: totalSupplierAmount,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: kHighLightColor),
                ),
                
              )
            ],
          ),
        ),
      ),
    );
  }
}
