// import 'package:flutter/material.dart';

// import '../../widgets/ledger/transaction_tile.dart';

// class CustomerTab extends StatelessWidget {
//   const CustomerTab({super.key, required String type});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TransactionTile(
//                 color: 0xff5099f5,
//                 name: 'Sunaina Pai',
//                 amount: '250',
//                 remarks: 'DUE',
//                 type: 'Payment',
//                 date: '1 July, 2023',
//               ),
//               TransactionTile(
//                 color: 0xff9675ce,
//                 name: 'Nitin Bargi',
//                 amount: '1,300',
//                 remarks: 'DUE',
//                 type: 'Payment',
//                 date: '17 Jun, 2023',
//               ),
//               TransactionTile(
//                 color: 0xff4dbd91,
//                 name: 'Aryan Shah',
//                 amount: '2,850',
//                 remarks: 'ADVANCE',
//                 type: 'Payment',
//                 date: '2 Jun, 2023',
//               ),
//               TransactionTile(
//                 color: 0xff4cb6ac,
//                 name: 'Dhruv Nanda',
//                 amount: '800',
//                 remarks: 'ADVANCE',
//                 type: 'Payment',
//                 date: '28 Mar, 2023',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:auto_size_text/auto_size_text.dart';
import 'package:credo/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'transaction_list.dart';
import '../../state/global_variables.dart';
import 'package:provider/provider.dart';

class CustomerTab extends StatefulWidget {
  final String type;
  final String searchQuery;
  const CustomerTab({super.key, required this.type, required this.searchQuery});

  @override
  _CustomerTabState createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  String? clientId;

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to schedule after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      // appState.setClientId('2');
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            clientId = appState.clientId;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Material(
                child: TabBar(
                  tabs: [
                    Tab(
                      child: SafeArea(
                        child: AutoSizeText(
                          S.of(context).credit,
                          maxLines: 2,  // Limit to 2 lines
                          minFontSize: 5,  // Minimum font size
                          style: TextStyle(
                            fontSize: 16, // Default font size
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Tab(
                      child: SafeArea(
                        child: AutoSizeText(
                          S.of(context).notification,
                          maxLines: 2,  // Limit to 2 lines
                          minFontSize: 5,  // Minimum font size
                          style: TextStyle(
                            fontSize: 16, // Default font size
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: clientId == null
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        children: [
                          TransactionList(
                            type: 'customer_credit',
                            clientid: clientId,
                            searchQuery: widget.searchQuery,
                          ),
                          TransactionList(
                            type: 'customer_notif',
                            clientid: clientId,
                            searchQuery: widget.searchQuery,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
