import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/data.dart';
import 'ledger/customer_tab.dart';
import 'ledger/supplier_tab.dart';
import './ledger/add_contact.dart';
import '../widgets/ledger/header.dart';
import '../widgets/ledger/search_box.dart';
import '../generated/l10n.dart';

class LedgerPage extends StatefulWidget {
  const LedgerPage({super.key});

  @override
  _LedgerPageState createState() => _LedgerPageState();
}

class _LedgerPageState extends State<LedgerPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          elevation: 4.0,
          onPressed: () { WidgetsBinding.instance.addPostFrameCallback((_) {
Navigator.pushNamed(context, AddContactPage.id).then((result) {
            if (result == true) {
              // You may refresh your list here if needed.
            }
          });});},
          icon: const Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          label: AutoSizeText(
                                          overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

            S.of(context).add_contact,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SF-Pro', fontSize: 15.0,
            ),
          ), 
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                const LedgerPageHeader(),
                const SizedBox(height: 20.0),
                // Pass search query updates from the SearchBox
                SearchBox(
                  onChanged: (query) {
                    Future.delayed(Duration.zero, (){
                      if(mounted){
                        setState(() {
                          searchQuery = query;
                        });
                      }
                    });
                    
                  },
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 310,
                      child: TabBar(
                        tabs: context.read<DataModel>().tabs,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Pass the search query to each tab so that they can filter the list
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // In CustomerTab, add an optional parameter for search query
                                  CustomerTab(type: 'customer_credit', searchQuery: searchQuery,),
                                  CustomerTab(type: 'customer_notif', searchQuery: searchQuery,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            Expanded(
                              child: TabBarView(
                                children: [
                                  // Similarly for SupplierTab (make sure to update its constructor)
                                  SupplierTab(type: 'supplier_credit', searchQuery: searchQuery,),
                                  SupplierTab(type: 'supplier_notif', searchQuery: searchQuery,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
