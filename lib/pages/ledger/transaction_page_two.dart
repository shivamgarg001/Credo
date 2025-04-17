import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'dart:convert';
import './transaction_page_three.dart';
import '../../state/global_variables.dart';
import 'package:provider/provider.dart';

class Pair<T, U> {
  final T first;
  final U second;

  Pair(this.first, this.second);
}

class TransactionDetailPageTwo extends StatefulWidget {
  final String clientid;
  final String customerid;
  final String type;
  final String phone_number;
  final String name;
  final dynamic ledger_id_to_new;

  const TransactionDetailPageTwo({
    super.key,
    required this.customerid,
    required this.clientid,
    required this.type,
    required this.phone_number,
    required this.name,
    this.ledger_id_to_new,
  });

  @override
  _TransactionDetailPageTwoState createState() =>
      _TransactionDetailPageTwoState();
}

class _TransactionDetailPageTwoState extends State<TransactionDetailPageTwo> {
  Map<String, dynamic> transactionDetails = {};
  bool isLoading = true;
  bool isLoadingappbar = false;
  
  bool showRefreshButton = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    await Future.delayed(
        Duration(milliseconds: 1000)); // Use a noticeable delay

    showErrorFlushbar(context, message);
  }

  Future<void> fetchTransactionDetails() async {
    final clientId = widget.clientid;
    final customerid = widget.customerid;
    final type = widget.type;

    String apiUrl = 'https://credo.up.railway.app/client/v1/supplier/get/';
    if (type == "customer_credit" || type == "supplier_notif") {
      apiUrl = 'https://credo.up.railway.app/client/v1/customer/get/';
    }

    dynamic response;
    try {
      if (type.contains("credit")) {
        response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Client-ID': clientId,
            'Customer-ID': customerid,
            'Supplier-ID': customerid,
          },
        );
      } else if (type.contains("notif")) {
        response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Client-ID': customerid,
            'Customer-ID': clientId,
            'Supplier-ID': clientId,
          },
        );
      }

      if (response.statusCode == 200) {
        print("PRINTING IN PAGE TWO ::::::::: ${response.body}");
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              transactionDetails = json.decode(response.body);
              isLoading = false;
              if (transactionDetails['ledgers'] != null) {
                transactionDetails['ledgers'].sort((a, b) {
                  DateTime dateA = DateTime.tryParse(a['updated_at'] ?? '') ??
                      DateTime.now();
                  DateTime dateB = DateTime.tryParse(b['updated_at'] ?? '') ??
                      DateTime.now();
                  return dateB.compareTo(dateA); // Sort in descending order
                });
              }
            });
          }
        });
      } else {
        print('Failed to load transaction details');
        Future.delayed(Duration.zero, () {
          if (mounted) setState(() => isLoading = false);
        });
      }
    } catch (e) {
      print('Error: $e');
      Future.delayed(Duration.zero, () {
        if (mounted) setState(() => isLoading = false);
      });
    }
  }

  Future<void> fetchUserDetails() async {
    setState(() {
      isLoadingappbar = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://credo.up.railway.app/client/v1/getclient/'),
        headers: {
          'Client-ID': widget.customerid,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> details = jsonDecode(response.body);
        print(details);

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            color: Colors.grey[700],
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.grey[800],
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Client information',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    // Divider
                    Container(
                      height: 1,
                      color: Colors.grey[200],
                    ),

                    SizedBox(height: 24),

                    // User details
                    DetailItem(
                      icon: Icons.person,
                      label: 'Name',
                      value: details['client_name'] ?? 'N/A',
                    ),

                    SizedBox(height: 20),

                    DetailItem(
                      icon: Icons.phone,
                      label: 'Phone Number',
                      value: details['phone_number'] ?? 'N/A',
                    ),

                    SizedBox(height: 20),

                    DetailItem(
                      icon: Icons.business,
                      label: 'Business Name',
                      value: details['business_name'] ?? 'N/A',
                    ),

                    SizedBox(height: 20),

                    DetailItem(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: details['address'] ?? 'N/A',
                    ),

                    SizedBox(height: 20),

                    DetailItem(
                      icon: Icons.receipt,
                      label: 'GST',
                      value: details['gst_number'] ?? 'N/A',
                    ),

                    SizedBox(height: 32),

                    // Close button
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Handle error if the API request fails
        print('Failed to load user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      setState(() {
        isLoadingappbar = false;
      });
    }
  }

  Future<void> _callDeleteApi() async {
    try {
      final clientId = widget.clientid;
      final customerid = widget.customerid;
      final type = widget.type;

      String apiUrl = 'https://credo.up.railway.app/client/v1/supplier/delete/';
      if (type == "customer_credit" || type == "customer_debit") {
        apiUrl = 'https://credo.up.railway.app/client/v1/customer/delete/';
      }

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': clientId,
          'Customer-ID': customerid,
          'Supplier-ID': customerid,
        },
      );

      if (response.statusCode == 200) {
        print('Contact deleted successfully');
        final appState = Provider.of<AppState>(context, listen: false);

        // Set ledger amount to 0 for all ledgers
        if (transactionDetails['ledgers'] != null) {
          for (var ledger in transactionDetails['ledgers']) {
            String ledgerId = ledger['ledger_id'];

            if (widget.type == 'customer_credit' ||
                widget.type == 'customer_notif') {
              appState.setCustomerLedgerAmount(customerid, ledgerId, 0.0);
            } else {
              appState.setSupplierLedgerAmount(customerid, ledgerId, 0.0);
            }
            // appState.setLedgerAmount(customerid, ledgerId, 0.0);
          }
        }

        if (mounted) {
          await _showSuccessAnimation();
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } else {
        _showErrorMessage("Failed to delete Contact");
        throw Exception('Failed to delete Contact');
      }
    } catch (e) {
      print('Error deleting customer/supplier: $e');
    }
  }

  void _deleteCustomer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText(
            S.of(context).delete_contact,
            overflow: TextOverflow.clip,
            maxLines: 2, // Allow wrapping
            minFontSize: 5, // Minimum font size
          ),
          content: AutoSizeText(
            S.of(context).delete_contact_confirmation,
            overflow: TextOverflow.clip,
            maxLines: 2, // Allow wrapping
            minFontSize: 5, // Minimum font size
          ),
          actions: [
            TextButton(
              child: AutoSizeText(
                S.of(context).cancel,
                overflow: TextOverflow.clip,
                maxLines: 2, // Allow wrapping
                minFontSize: 5, // Minimum font size
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: AutoSizeText(
                S.of(context).delete,
                overflow: TextOverflow.clip,
                maxLines: 2, // Allow wrapping
                minFontSize: 5, // Minimum font size
              ),
              onPressed: () async {
                await _callDeleteApi();
                if (mounted) {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addLedger() async {
    final clientId = widget.clientid;
    final customerid = widget.customerid;

    final ledgerNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isAddingLedger = false;

        return AlertDialog(
          title: AutoSizeText(
            S.of(context).add_ledger,
            overflow: TextOverflow.clip,
            maxLines: 2, // Allow wrapping
            minFontSize: 5, // Minimum font size
          ),
          content: TextField(
            controller: ledgerNameController,
            decoration: InputDecoration(
              labelText: S.of(context).ledger_name,
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: AutoSizeText(
                S.of(context).cancel,
                overflow: TextOverflow.clip,
                maxLines: 2, // Allow wrapping
                minFontSize: 5, // Minimum font size
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return TextButton(
                  onPressed: isAddingLedger
                      ? null
                      : () async {
                          setState(() => isAddingLedger = true);
                          await addLedgerAPI(ledgerNameController);
                          setState(() => isAddingLedger = false);
                          Navigator.of(context).pop();
                        },
                  child: isAddingLedger
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : SafeArea(
                          child: AutoSizeText(
                            S.of(context).add,
                            maxLines: 2,
                            minFontSize: 5,
                          ),
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addLedgerAPI(TextEditingController ledgerNameController) async {
    final ledgerName = ledgerNameController.text.trim();

    if (ledgerName.isNotEmpty) {
      try {
        String apiUrl =
            'https://credo.up.railway.app/client/v1/supplier/ledger/add/';
        if (widget.type == "customer_credit" || widget.type == "customer_debit") {
          apiUrl =
              'https://credo.up.railway.app/client/v1/customer/ledger/add/';
        }

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Client-ID': widget.clientid,
            'Customer-ID': widget.customerid,
            'Supplier-ID': widget.customerid,
          },
          body: {
            'name': ledgerName,
          },
        );

        if (response.statusCode == 200) {
          print('Ledger added successfully');
          // Optionally refresh the transaction details
          await _showSuccessAnimation();
          await fetchTransactionDetails();
        } else {
          _showErrorMessage("Failed to add ledger");
          throw Exception('Failed to add ledger');
        }
      } catch (e) {
        print('Error adding ledger: $e');
      }
    } else {
      showErrorFlushbar(context, 'Please enter a ledger name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          S.of(context).ledger_details,
          overflow: TextOverflow.clip,
          maxLines: 2, // Allow wrapping
          minFontSize: 5, // Minimum font size
        ),
        actions: [
          isLoadingappbar
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () async {
                    setState(() => isLoadingappbar = true);
                    await fetchUserDetails();
                    setState(() => isLoadingappbar = false);
                  },
                  tooltip: "Info",
                ),
          isLoadingappbar
              ? SizedBox() // Or you can show nothing, or another spinner
              : IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () async {
                    setState(() => isLoadingappbar = true);
                    await fetchTransactionDetails();
                    setState(() => isLoadingappbar = false);
                  },
                  tooltip: "Fetch Ledger Details",
                ),
          if ((widget.type == "customer_credit" ||
                  widget.type == "supplier_credit") &&
              !isLoadingappbar)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                await _addLedger();
              },
              tooltip: S.of(context).add_ledger,
            )
        ],
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/animation/Loading.json',
                    width: 200,
                    height: 200,
                    repeat: true,
                  ),
                )
              : transactionDetails['ledgers']?.isEmpty ?? true
                  ? Center(
                      child: Lottie.asset(
                        'assets/animation/NotFound.json',
                        width: 200,
                        height: 200,
                        repeat: true,
                      ),
                    )
                  : ListView.builder(
                      controller:
                          _scrollController, // Add scrollController here
                      itemCount: transactionDetails['ledgers']?.length ?? 0,
                      itemBuilder: (context, index) {
                        final ledger = transactionDetails['ledgers'][index];
                        final customerId = widget.customerid;
                        final ledgerId = ledger['ledger_id'];
                        final ledgerName = ledger['ledger_name'] ?? '';

                        int newtag = 1;

                        newtag = widget.ledger_id_to_new?[ledgerId] ?? 1;

                        // double total_amount = widget.ledger_id_to_new[ledgerId]!.second;

                        final appState = Provider.of<AppState>(context);
                        bool isCustomer = (widget.type == 'customer_credit' ||
                                widget.type == 'customer_notif')
                            ? true
                            : false;
                        double ledgerAmount = (isCustomer
                                ? appState.customerLedgerAmounts[customerId]
                                : appState.supplierLedgerAmounts[
                                    customerId])?[ledgerId] ??
                            0.0;

                        // if (widget.type.contains("notif")) {
                        //   ledgerAmount = total_amount;
                        // }

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Stack(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: AutoSizeText('L${index + 1}'),
                                ),
                                title: AutoSizeText(ledgerName),
                                subtitle: AutoSizeText('${S.of(context).amount}: ₹ ${(((ledgerAmount) * 100).round()) / 100}'),
                                trailing: Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LedgerDetailPage(
                                          type: widget.type,
                                          clientid: widget.clientid,
                                          customerid: widget.customerid,
                                          ledgerid: ledger['ledger_id'],
                                          phone_number:
                                              widget.phone_number.toString(),
                                          name: widget.name,
                                        ),
                                      ),
                                    ).then((result) async {
                                      if (result == true) {
                                        await fetchTransactionDetails();
                                      }
                                    });
                                  });
                                },
                              ),
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
                          ),
                        );
                      },
                    ),
        ],
      ),

      //   floatingActionButton: (widget.type == "customer_credit" || widget.type == "supplier_credit")
      //       ? FloatingActionButton(
      //           onPressed: _deleteCustomer,
      //           backgroundColor: Colors.red,
      //           child: Icon(Icons.delete),
      //         )
      //       : null,
    );
  }
}

// Custom widget for detail items
class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
