// import 'package:flutter/material.dart';

// class SupplierTab extends StatelessWidget {
//   const SupplierTab({super.key, required String type});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20.0),
//               Image.asset(
//                 'assets/images/supplier.png',
//                 width: 280.0,
//               ),
//               const SizedBox(height: 10.0),
//               const AutoSizeText(
//                 'Add all your supplier here and save time by easily recording sale/purchase done with them.',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               )
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

class SupplierTab extends StatefulWidget {
  final String type;
  final String searchQuery;
  const SupplierTab({super.key, required this.type, required this.searchQuery});

  @override
  _SupplierTabState createState() => _SupplierTabState();
}

class _SupplierTabState extends State<SupplierTab> {
  String? clientId;

  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to schedule after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
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
                            type: 'supplier_credit',
                            clientid: clientId,
                            searchQuery: widget.searchQuery,
                          ),
                          TransactionList(
                            type: 'supplier_notif',
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
