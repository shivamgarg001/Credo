import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import '../../widgets/ledger/transaction_tile.dart';
import '../ledger/transaction_page_two.dart';
import 'package:provider/provider.dart';
import '../../state/global_variables.dart';
import 'package:intl/intl.dart';

// class Pair<T, U> {
//   final T first;
//   final U second;

//   Pair(this.first, this.second);
// }

class TransactionList extends StatefulWidget {
  final String type;
  final String? clientid;
  final String searchQuery;
  const TransactionList(
      {super.key,
      required this.type,
      required this.clientid,
      required this.searchQuery});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<dynamic> transactions = [];
  List<dynamic> filteredTransactions = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();
  double totalCustomerAmount = 0.0;
  double totalSupplierAmount = 0.0;
  bool showRefreshButton = true; // For controlling the visibility of the refresh button

  @override
  void initState() {
    super.initState();
    fetchTransactions();
    print(DateTime.now().toString());
    // Listener for scroll position
    _scrollController.addListener(() {
      if (_scrollController.offset <= 100) {
        // When scrolled near the top, show the refresh button
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              showRefreshButton = true;
            });
          }
        });
      } else {
        // Hide the button when scrolled down even slightly
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              showRefreshButton = false;
            });
          }
        });
      }
    });
  }

  void filterTransactions() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          if (widget.searchQuery.isEmpty) {
            filteredTransactions = transactions;
          } else {
            filteredTransactions = transactions.where((transaction) {
              String title = transaction['title'].toString().toLowerCase() ??
                  ''; // <-- Adjust based on your data structure
              return title.contains(widget.searchQuery.toLowerCase());
            }).toList();
          }
        });
      }
    });
  }

  Future<void> _showSuccessAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Lottie.asset('assets/animation/SuccessAnimation.json',
                width: 200, height: 200, repeat: false),
          ),
        );
      },
    );

    await Future.delayed(
        const Duration(milliseconds: 800)); // Wait for animation to complete
    Navigator.of(context).pop(); // Close the dialog after delay
  }

  Future<void> _showFailureAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing manually
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Lottie.asset('assets/animation/FailAnimation.json',
                width: 200, height: 200, repeat: false),
          ),
        );
      },
    );

    await Future.delayed(
        const Duration(milliseconds: 800)); // Wait for animation to complete
    Navigator.of(context).pop(); // Close the dialog after delay
  }

  String getApiEndpoint() {
    switch (widget.type) {
      case 'customer_credit':
        return 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/getall/';
      case 'customer_notif':
        return 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/invoice/auto_getall/';
      case 'supplier_credit':
        return 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/supplier/getall/';
      case 'supplier_notif':
        return 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/supplier/invoice/auto_getall/';
      default:
        return 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/getall/';
    }
  }

  void showNetworkErrorAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Lottie.asset('assets/animation/NetworkError.json'),
        ),
      ),
    );
  }

  Future<void> fetchTransactions() async {
    if (isLoading || !mounted) return;

    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() => isLoading = true);
      }
    });

    List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showNetworkErrorAnimation();
    }

    try {
      print("Sending GET request to: ${getApiEndpoint()}");

      final response = await http.get(Uri.parse(getApiEndpoint()),
          headers: {'Client-ID': widget.clientid ?? ''});

      print("Received response with status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("here i am in response status transaction list... ${response.body}");

        if (widget.type == 'supplier_notif' || widget.type == 'customer_notif') {
          final clientIdsMap = Map<String, dynamic>.from(json.decode(response.body)['client1_ids']);

          if (clientIdsMap.isEmpty) {
            Future.delayed(Duration.zero, () {
              if (mounted) {
                setState(() {
                  transactions = [];
                  filterTransactions();
                });
              }
            });
          } 
          else {
            List<dynamic> newTransactions = [];
            for (dynamic clientId in clientIdsMap.keys) {
              
              String clientName = clientIdsMap[clientId]['client_name'];
              String phoneNumber = clientIdsMap[clientId]['phone_number'];
              Map<String,dynamic> ledgerMapping={"temp":1};
              List<dynamic> fetchedTransactions = await _fetchEverything(clientId, clientIdsMap[clientId]!['client_name']!, ledgerMapping);
              double amount = 0.0;
              
              print("..................................... $ledgerMapping");
              int newornot = 0;
              for (dynamic item in fetchedTransactions) {
                if(item['new']==1)  newornot=1;
                print('Transaction Amount: ${item["amount"]}');
                amount = amount + item["amount"];
              }

              List<dynamic> allInfo = [
                {
                  "name": clientName,
                  "custsuppid" : clientId,
                  "phone_number": phoneNumber,
                  "amount": amount,
                  "new":newornot,
                  "invoice_list": fetchedTransactions,
                  "ledger_mapping":ledgerMapping,
                }
              ];

              newTransactions.addAll(allInfo);
              print("Transactions are: $newTransactions");
            }

            Future.delayed(Duration.zero, () {
              if (mounted) {
                setState(() {
                  transactions.clear();
                  transactions.addAll(newTransactions);
                  transactions.sort((a, b) {
                    DateTime dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime.now();
                    DateTime dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime.now();
                    return dateB.compareTo(dateA); // Sorting in descending order
                  });
                  
                  filterTransactions();
                });
              }
            });
          }
        } 
        else {
          final List<dynamic> data = json.decode(response.body);

          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                transactions = (data.map((item) {
                  final appState = Provider.of<AppState>(context, listen: false);
                  final clientId = item['client_id']?.toString() ?? '';

                  double totalAmount = 0.0;
                  if (widget.type == 'customer_credit') {
                    totalAmount = appState
                                  .customerLedgerAmounts[clientId]?.values
                                  .fold(0.0, (sum, amount) {
                                    return (sum ?? 0.0) + (amount ?? 0.0);
                                  }) ?? 0.0;

                    totalCustomerAmount += totalAmount;
                    appState.setTotalCustomerAmount(totalCustomerAmount);
                  } 
                  else if(widget.type == 'supplier_credit'){
                    totalAmount = appState
                                  .supplierLedgerAmounts[clientId]?.values
                                  .fold(0.0, (sum, amount) {
                                    return (sum ?? 0.0) + (amount ?? 0.0);
                                  }) ?? 0.0;
                    totalSupplierAmount += totalAmount;
                    appState.setTotalSupplierAmount(totalSupplierAmount);
                  }
                  int newtag = 0; // Default value
                  if (item['ledger_mapping'] != null) {
                    item['ledger_mapping'].forEach((key, value) {
                      if (value == 1) {
                        newtag = 1;
                      }
                    });
                  }
                  print(widget.clientid);
                  print("here i am tu ${item['ledger_mapping']}");
                  return {
                    'customer_id': item['client_id'],
                    'name': item['client_name'],
                    'amount': totalAmount,
                    'phone_number': item['phone_number'],
                    'date': '',
                    'status': '',
                    'type': 'debit',
                    'new':newtag,
                    'ledger_mapping':item['ledger_mapping']
                  };
                }).toList());

                page++;
                hasMore = data.isEmpty;
                transactions.sort((a, b) {
                  DateTime dateA = DateTime.tryParse(a['date_created'] ?? '') ?? DateTime.now();
                  DateTime dateB = DateTime.tryParse(b['date_created'] ?? '') ?? DateTime.now();
                  return dateB.compareTo(dateA); // Ascending order
                });
                filterTransactions();
              });
            }
          });
        }
      } 
      else {
        print("Error response: ${response.body}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    } finally {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() => isLoading = false);
        }
      });
    }
  }

  Future<List<dynamic>> _fetchEverything(String custSuppId, String? clientName, Map<String,dynamic> ledgerMapping) async {
    List<dynamic> newTransactions = [];

    try {
      String apiUrl = widget.type.contains('customer')
          ? 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/invoice/auto_get/'
          : 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/supplier/invoice/auto_get/';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid ?? '',
          'Customer-ID': custSuppId,
          'Supplier-ID': custSuppId
        },
      );

      // print("FINAL RESPONSE IS: ${response.body}");

      if (response.statusCode == 200) {
        final ledgerData = json.decode(response.body);
        print("jkadnkjankjnajksncjkan $ledgerData");
        if (ledgerData is List) {

          Map<String, dynamic> newLedgerMapping = ledgerData[0]['ledger_mapping'];
          ledgerMapping.addAll(newLedgerMapping);        

          for (var ledgerItem in ledgerData) {
            print("akjsncsakcakjscxkjsbqjkcb kcb hkbchq $ledgerMapping");
            final ledger = ledgerItem['ledger'];
            final data = ledger['data'];
            final ledgerId = ledger['_id'];
            final newornot = ledger['new'];
            final String ledgerName = ledger['ledger_name'] ?? '';

            for (var transaction in data) {
              print("/////////////////////////// $transaction");
              final chatId = transaction['chat_id'] ?? "unknown";
              final description = (transaction['description'] ?? '').isNotEmpty
                  ? transaction['description']
                  : 'No Description';

              final quantity =
                  double.tryParse(transaction['quantity'].toString()) ?? 0.0;
              final rate =
                  double.tryParse(transaction['rate'].toString()) ?? 0.0;
              final amount =
                  double.tryParse(transaction['amount'].toString()) ?? 0.0;
              final dateCreated = transaction['date_created'] ?? "unknown";
              DateTime parsedDate =
                  DateTime.tryParse(dateCreated) ?? DateTime.now();
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(parsedDate);
              
              newTransactions.add({
                'chat_id': chatId,
                'description': description,
                'quantity': quantity,
                'rate': rate,
                'amount': amount,
                'date': formattedDate,
                'customer_id': custSuppId,
                'name': clientName,
                'type': 'debit',
                'status': '',
                'ledgerid': ledgerId,
                'ledger_name':ledgerName,
                'new':newornot
              });
            }
          }
        } else {
          print("Error: ledgerData is not a list.");
        }
      } else {
        print("Error response: ${response.body}");
      }
    } catch (e) {
      print("Exception occurred while fetching ledger: $e");
    }
    print(newTransactions);
    return newTransactions; // Return fetched data
  }

  @override
  void didUpdateWidget(covariant TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      filterTransactions(); // <-- Re-filter when search query changes
    }
  }

@override
Widget build(BuildContext context) {
  List<dynamic> filteredTransactions = transactions.where((transaction) {
    String name = transaction['name'].toString().toLowerCase() ?? ''; // Ensure safe lookup
    String description = transaction['description'].toString().toLowerCase() ?? '';
    return name.contains(widget.searchQuery.toLowerCase()) || description.contains(widget.searchQuery.toLowerCase());
  }).toList();
  return SafeArea(
    child: RefreshIndicator(
      onRefresh: fetchTransactions,
      child: Stack(
        children: [
          isLoading
              ? Center(
                  child: Lottie.asset(
                      'assets/animation/Loading.json',
                      width: 200,
                      height: 200,
                      repeat: true),
                )
              : filteredTransactions.isEmpty
                  ? Center(
                      child: Lottie.asset(
                          'assets/animation/NotFound.json',
                          width: 200.0,
                          height: 200.0,
                          repeat: true),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        int newtag = transaction['new'] ?? 0;
                        double amount = transaction['amount']??0.0;

                        // Wrap the entire return in a Stack to allow Positioned widgets
                        return Stack(
                          children: [
                            // Transaction item
                            GestureDetector(
                              onTap: () {
                                if (widget.type == 'customer_credit' || widget.type == 'supplier_credit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionDetailPageTwo(
                                        type: widget.type,
                                        clientid: widget.clientid ?? '',
                                        customerid: transaction['customer_id'].toString(),
                                        phone_number: transaction['phone_number'].toString(),
                                        name: transaction['name'].toString(),
                                        ledger_id_to_new: transaction['ledger_mapping'],
                                      ),
                                    ),
                                  ).then((result) async {
                                    if (result == true || result == null) {
                                      await fetchTransactions();
                                    }
                                  });
                                } else {
                                  final name = transaction['name'];
                                  final phoneNumber = transaction['phone_number'];
                                  final custsuppid = transaction["custsuppid"];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TransactionDetailPageTwo(
                                        type: widget.type,
                                        clientid: widget.clientid ?? '', 
                                        name: name,
                                        customerid: custsuppid,
                                        phone_number: phoneNumber,
                                        ledger_id_to_new: transaction['ledger_mapping'],
                                      ),
                                    ),
                                  ).then((result) async {
                                    if (result == true || result == null) {
                                      await fetchTransactions();
                                    }
                                  });
                                }
                              },
                              child: TransactionTile(
                                color: 0xff5099f5,
                                name: transaction['name'],
                                amount: (((transaction['amount'] * 100).round()) / 100),
                                remarks: transaction['status'] ?? '',
                                type: transaction['type'] ?? '',
                                date: transaction['date'] ?? '',
                                
                              ),
                            ),
                            // Display the "New" tag if `newtag == 1`
                            if (newtag == 1)
                              Positioned(
                                top: 33,
                                right: 0,
                                child: Lottie.asset(
                                  'assets/animation/New.json',
                                  width: 50,
                                  height: 50,
                                  repeat: true,
                                ),
                              ),
                          ],
                        );
                      
                      },
                    ),
          // The refresh button
          if (showRefreshButton)
            Positioned(
              bottom: 10,
              left: 0,
              child: FloatingActionButton(
                onPressed: fetchTransactions,
                backgroundColor: Colors.blue,
                autofocus: true,
                mini: true,
                child: Icon(
                  Icons.refresh,
                ),
              ),
            ),
        ],
      ),
    ),
  );
  }

}
