import 'package:auto_size_text/auto_size_text.dart';
import 'package:credo/pages/ledger/invoicegenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/pages/ledger/send_money.dart';
import 'dart:convert';
import 'add_receipt_page.dart';
import 'transaction_detail_page.dart'; // New detailed page
import '../../state/global_variables.dart';
import 'package:provider/provider.dart';

class LedgerDetailPage extends StatefulWidget {
  final String clientid;
  final String customerid;
  final String ledgerid;
  final String type;
  final String phone_number; 
  final String name;

  const LedgerDetailPage({
    super.key,
    required this.customerid,
    required this.clientid,
    required this.type,
    required this.ledgerid, 
    required this.phone_number, 
    required this.name,
  });

  @override
  _LedgerDetailPageState createState() => _LedgerDetailPageState();
}

class _LedgerDetailPageState extends State<LedgerDetailPage> {
  bool isLoading = true;
  Map<String, dynamic> ledgerDetails = {};
  bool showRefreshButton = true;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    fetchLedgerDetails();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Match this with your AppBar color
      statusBarIconBrightness: Brightness.light, // Change if needed
    ));
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
    super.dispose();
    // Reset the system UI to default when widget is disposed
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
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

    await Future.delayed(const Duration(milliseconds: 800)); // Wait for animation to complete
    if(mounted){
      Navigator.of(context).pop();
    } // Close the dialog after delay
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
    if(mounted){Navigator.of(context).pop(); }// Close the dialog after delay
  }

  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    await Future.delayed(
        Duration(milliseconds: 1000)); // Use a noticeable delay

    showErrorFlushbar(context, message);
  }

  Future<void> fetchLedgerDetails() async {
    String apiUrl = widget.type.contains('customer')
        ? 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/ledger/get/'
        : 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/supplier/ledger/get/';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid
        },
      );

      if (response.statusCode == 200) {
        // print("response.body is ///////////// ${response.body}");
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              ledgerDetails = json.decode(response.body);

              isLoading = false;
              if (ledgerDetails['data'] != null) {
                ledgerDetails['data'].sort((a, b) {
                  DateTime dateA = DateTime.tryParse(a['updated_at'] ?? '') ?? DateTime.now();
                  DateTime dateB = DateTime.tryParse(b['updated_at'] ?? '') ?? DateTime.now();
                  return dateB.compareTo(dateA);
                });
              }

              final appState = Provider.of<AppState>(context, listen: false);

              if (widget.type == 'customer_credit') {
                appState.setCustomerLedgerAmount(widget.customerid, widget.ledgerid, ledgerDetails['total_amount']);
              } 
              else if(widget.type == 'supplier_credit'){
                appState.setSupplierLedgerAmount(widget.customerid, widget.ledgerid, ledgerDetails['total_amount']);
              }
              // appState.setLedgerAmount(widget.customerid, widget.ledgerid, ledgerDetails['total_amount']);
            });
          }
        });
      } 
      else {
        throw Exception('Failed to load ledger details');
      }
    } catch (e) {
      print(e);
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            ledgerDetails = {
              'ledger_name': 'Error loading data',
              'created_at': DateTime.now().toIso8601String(),
              'total_amount': 0.0,
              'data': []
            };
            isLoading = false;
          });
        }
      });
    }
  }

  void showDeleteConfirmationDialog() async{
    showDialog(
      context: context,
      builder: (context) => SafeArea(
        child: AlertDialog(
          title: AutoSizeText(
            S.of(context).delete_ledger,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          content: AutoSizeText(
            S.of(context).delete_ledger_confirmation,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pop(context);
                }
              }, // Close the dialog
              child: AutoSizeText(
                S.of(context).cancel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                });
                await deleteLedger(); // Call delete ledger API
              },
              child: AutoSizeText(
                S.of(context).delete,
                style: TextStyle(color: Colors.red),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteLedger() async {
    String apiUrl = widget.type.contains('customer')
        ? 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/customer/ledger/delete/'
        : 'http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/client/v1/supplier/ledger/delete/';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid
        },
      );

      if (response.statusCode == 200) {
        final appState = Provider.of<AppState>(context, listen: false);

        if (widget.type == 'customer_credit' ||
            widget.type == 'customer_notif') {
          appState.setCustomerLedgerAmount(
              widget.customerid, widget.ledgerid, 0.0);
        } else {
          appState.setSupplierLedgerAmount(
              widget.customerid, widget.ledgerid, 0.0);
        }
        // appState.setLedgerAmount(widget.customerid, widget.ledgerid, 0.0);

        await _showSuccessAnimation();
        if (mounted) {
          Navigator.pop(context, true);
        }

        showSuccessFlushbar(context, 'Ledger deleted successfully');
      } else {
        _showErrorMessage("Failed to delete ledger");
      }
    } catch (e) {
      showErrorFlushbar(context, 'Error deleting ledger');
    }
  }

  Future<void> fetchInvoicePdf() async {
    DateTimeRange selectedRange = await pickDateRange(context);

      List<Map<String, dynamic>> items = [];
  
        for (var transaction in ledgerDetails['data']) {
    DateTime transactionDate = DateTime.parse(transaction['created_at']);
    if (transactionDate.isAfter(selectedRange.start) && transactionDate.isBefore(selectedRange.end)) {
      items.add({
        'name': transaction['description'].toString(),
        'description': transaction['description'].toString(),
        'quantity': transaction['quantity'] ?? 0.0,
        'rate': transaction['rate'] ?? 0.0,
        'amount': transaction['amount'] ?? 0.0,
        'date': transaction['created_at'] ?? DateTime.now(),
      });
    }
  }
    dynamic pdf = json.encode({
        'customer': {
          'name': widget.name,        // Customer's name
          'phone': widget.phone_number, // Customer's phone number
        },
        'items': items,
      });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceGenerator(jsonData: pdf),
      ),
    );

    // final response = await http.post(
    //   Uri.parse("http://ec2-65-0-134-141.ap-south-1.compute.amazonaws.com/biz/v1/generate-invoice/"),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     // Add other necessary headers like Authorization if required
    //   },
    //   body: json.encode({
    //     'customer': {
    //       'name': widget.name,        // Customer's name
    //       'phone': widget.phone_number, // Customer's phone number
    //     },
    //     'items': items,
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   showPdf(response.bodyBytes);
      
    //   print('Invoice generated successfully: ${response.body}');
    // } else {
    //   // Handle error (API call failed)
    //   print('Failed to generate invoice. Error: ${response.statusCode}');
    // }
  }


  // void showPdf(List<int> pdfBytes) async{
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PdfViewScreen(pdfBytes: pdfBytes),
  //     ),
  //   );
  // }

  Future<DateTimeRange> pickDateRange(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(Duration(days: 30)),
        end: DateTime.now().add(Duration(days: 1)),
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            hintColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ) ?? DateTimeRange(start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));
  }

  @override
  Widget build(BuildContext context) {
    // Safely access and check for null or empty data
    List<dynamic> transactions = ledgerDetails['data'] ?? [];

    // Group transactions by date
    Map<String, List<Map<String, dynamic>>> groupedTransactions = {};
    double pendingamount = 0.0;
    double orderValue = 0.0;
    double amountSentReceived = 0.0;

    for (var transaction in transactions) {
      if (transaction['created_at'] != null) {
        String dateKey = DateTime.parse(transaction['created_at'])
            .toLocal()
            .toString()
            .split(' ')[0]; // Extract date part (yyyy-mm-dd)
        groupedTransactions.putIfAbsent(dateKey, () => []).add(transaction);
      }
      bool incomingInCredit = (transaction['tag'] == 'S' && widget.type.contains("credit"));
      bool incomingInNotif = (transaction['tag'] == 'C' && widget.type.contains("notif"));
      bool outgoingInCredit = (transaction['tag'] == 'C' && widget.type.contains("credit"));
      bool outgoingInNotif = (transaction['tag'] == 'S' && widget.type.contains("notif"));

      if(transaction['status']==0)  pendingamount += ((transaction['amount']<0.0) ? -transaction['amount'] : transaction['amount']);
      if(outgoingInCredit) orderValue += transaction['amount'];
      if(incomingInNotif)  orderValue += transaction['amount'];
      if(outgoingInNotif) amountSentReceived += transaction['amount'];
      if(incomingInCredit)  amountSentReceived += transaction['amount'];
    }
    if(amountSentReceived<0.0){
      amountSentReceived = -amountSentReceived;
    }
    if(pendingamount<0.0){
      pendingamount = -pendingamount;
    }
    if(orderValue<0.0){
      orderValue = -orderValue;
    }

    String AmountReceivedorSentString = (widget.type.contains('notif')) ? "Amount Sent" : "Amount Received" ;
    
    // Future.delayed(Duration.zero, () {
    //     if (mounted) {
    //       setState(() {
    //         pendingAmount = pendingamount;
    //         amountSentReceived = amountSentReceived;
    //         orderValue = orderValue;
    //       });
    //     }
    //   });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            ledgerDetails['ledger_name'] ?? S.of(context).ledgerDetails,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w500, 
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: fetchLedgerDetails,
              tooltip: "Fetch Ledger Details",
            ),
            IconButton(
              icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
              onPressed: fetchInvoicePdf,
              tooltip: "Generate PDF",
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: fetchLedgerDetails, // Pull to refresh functionality
          child: Stack(
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Card(
                            elevation: 2, // Reduced elevation for a softer look
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16), // Slightly larger radius for a smoother, modern look
                            ),
                            color: Colors.white, // Clean background color
                            child: Padding(
                              padding: EdgeInsets.all(20), // More spacious padding
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Created At
                                  AutoSizeText(
                                    '${S.of(context).created_at} ${DateTime.parse(ledgerDetails['created_at']).toLocal().toString().split(' ')[0]}',
                                    style: TextStyle(
                                      fontSize: 14, // Reduced font size for a more balanced appearance
                                      color: Colors.grey[700], // Softer gray
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12), // Increased space between sections

                                  // Approved Amount
                                  InfoRow(
                                    label: "Total Amount",
                                    value: '₹ ${((ledgerDetails['total_amount'] * 100).round()) / 100}',
                                    valueColor: Colors.blueAccent,
                                  ),
                                  // Pending Amount
                                  InfoRow(
                                    label: "Pending Amount",
                                    value: '₹ $pendingamount',
                                    valueColor: Colors.orangeAccent,
                                  ),
                                  
                                  // Order Value
                                  InfoRow(
                                    label: "Order Value",
                                    value: '₹ $orderValue',
                                    valueColor: Colors.greenAccent,
                                  ),
                                  
                                  // Amount Received
                                  InfoRow(
                                    label: AmountReceivedorSentString,
                                    value: '₹ $amountSentReceived',
                                    valueColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                            ),
                          ),

                            SizedBox(height: 20),
                            AutoSizeText(
                              S.of(context).transactions,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 10),
  groupedTransactions.isEmpty
    ? Center(
        child: Lottie.asset(
          'assets/animation/NotFound.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
      )
    : Column(
        children: groupedTransactions.keys.map((date) {
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AutoSizeText(
                  date,
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...groupedTransactions[date]!.map((transaction) {

                print(transaction);
                dynamic color = (transaction['status']==1) ? Colors.greenAccent : Colors.orangeAccent;
                bool isNew = (transaction['new'] == 1);
                return Card(
                  surfaceTintColor: (transaction['status']==1) ? Color.fromARGB(255, 0, 255, 30) : Colors.white,
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  child: Stack(
                    
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.receipt_long,
                          color: color,
                        ),
                        title: AutoSizeText(
                          transaction['description'] is List
                              ? (transaction['description'] as List).join(", ")
                              : transaction['description'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: _getSubtitleWidget(transaction),
                        trailing: _getTrailingWidget(transaction),
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionDetailPage(
                                  side: false,
                                  transactionData: transaction,
                                  type: widget.type,
                                  clientid: widget.clientid,
                                  customerid: widget.customerid,
                                  ledgerid: widget.ledgerid,
                                  phone_number: widget.phone_number.toString(),
                                  name: widget.name,
                                  tag: transaction["tag"],
                                ),
                              ),
                            ).then((result) async {
                              if (result == true) {
                                await fetchLedgerDetails();
                              }
                            });
                          });
                        },
                      ),

                      if (isNew && (transaction['sender_id'] != widget.clientid ))
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
                      if (isNew && (transaction['sender_id'] == widget.clientid))
                        Positioned(
                          top: 45,
                          right: 10,
                          child: Icon(
                            Icons.done,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      if (!isNew )
                        Positioned(
                          top: 45,
                          right: 10,
                          child: Icon(
                            Icons.done_all,
                            color: Colors.green,
                            size: 20,
                          ),
                        ),                  
                      ],
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
        
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: (widget.type == "customer_credit" || widget.type == "supplier_credit")      
        ? SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ElevatedButton.icon(
            icon: Icon(Icons.add, color: Colors.white),
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: AutoSizeText(
                S.of(context).add_receipt,
                style: TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReceiptPage(
                      clientid: widget.clientid,
                      customerid: widget.customerid,
                      ledgerid: widget.ledgerid,
                      type: widget.type,
                      phone_number: widget.phone_number.toString(),
                      name: widget.name.toString(),
                    ),
                  ),
                ).then((result) async {
                  if (result == true) {
                    await fetchLedgerDetails();
                  }
                });
              });
            },
          ),
        )
        : SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ElevatedButton.icon(
            icon: Icon(Icons.send, color: Colors.white),
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: AutoSizeText(
                S.of(context).sendMoney,
                style: TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendMoney(
                      clientid: widget.clientid,
                      customerid: widget.customerid,
                      ledgerid: widget.ledgerid,
                      type: widget.type,
                      phone_number: widget.phone_number.toString(),
                      name: widget.name.toString(),
                    ),
                  ),
                ).then((result) async {
                  if (result == true) {
                    await fetchLedgerDetails();
                  }
                });
              });
            },
          ),
        ),
      
      ),);
  }

  Widget _getTrailingWidget(Map transaction) {
  bool incomingInCredit = (transaction['tag'] == 'S' && widget.type.contains("credit"));
  bool incomingInNotif = (transaction['tag'] == 'C' && widget.type.contains("notif"));
  bool outgoingInCredit = (transaction['tag'] == 'C' && widget.type.contains("credit"));
  bool outgoingInNotif = (transaction['tag'] == 'S' && widget.type.contains("notif"));

  // For incoming
  if (outgoingInCredit) {
    return Transform.rotate(
      angle: (3.14 / 4), // Rotate the icon for slant (45 degrees)
      child: Icon(
        Icons.arrow_upward, // Upward arrow
        size: 24,
        color: Colors.red, // Green for incoming
      ),
    );
  }
  
  // For outgoing
  if (incomingInCredit) {
    return Transform.rotate(
      angle: (3.14 / 4), // Rotate the icon for slant (-45 degrees)
      child: Icon(
        Icons.arrow_downward, // Downward arrow
        size: 24,
        color: Colors.green, // Red for outgoing
      ),
    );
  }
  if (outgoingInNotif) {
    return Transform.rotate(
      angle: -3*(3.14 / 4), // Rotate the icon for slant (-45 degrees)
      child: Icon(
        Icons.arrow_downward, // Downward arrow
        size: 24,
        color: Colors.red, // Red for outgoing
      ),
    );
  }
  if (incomingInNotif) {
    return Transform.rotate(
      angle: (3.14 / 4), // Rotate the icon for slant (-45 degrees)
      child: Icon(
        Icons.arrow_downward, // Downward arrow
        size: 24,
        color: Colors.green, // Red for outgoing
      ),
    );
  }

  // Default case: If neither incoming nor outgoing
  return Icon(
    Icons.arrow_forward_ios, // Default icon
    size: 16,
    color: Colors.grey[400],
  );
}

  Widget _getSubtitleWidget(Map transaction) {
    bool incomingInCredit = (transaction['tag'] == 'S' && widget.type.contains("credit"));
    bool incomingInNotif = (transaction['tag'] == 'C' && widget.type.contains("notif"));
    bool outgoingInCredit = (transaction['tag'] == 'C' && widget.type.contains("credit"));
    bool outgoingInNotif = (transaction['tag'] == 'S' && widget.type.contains("notif"));

    // For incoming
    if (outgoingInCredit) {
      return AutoSizeText(
        '${S.of(context).orderValue} ₹ ${transaction['amount']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    // For outgoing
    if (incomingInCredit) {
      return AutoSizeText(
        '${S.of(context).moneyReceived}: ₹ ${-1*transaction['amount']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (outgoingInNotif) {
      return AutoSizeText(
        '${S.of(context).moneySent} ₹ ${-1*transaction['amount']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (incomingInNotif) {
      return AutoSizeText(
        '${S.of(context).orderValue} ₹ ${transaction['amount']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Default case: If neither incoming nor outgoing
    return AutoSizeText(
      '₹ ${transaction['amount']}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

}
// Helper Widget for displaying the label-value pairs
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({super.key, required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8), // Space between each row
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600], // Lighter gray for label
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AutoSizeText(
            value,
            style: TextStyle(
              fontSize: 16,
              color: valueColor, // Dynamic color based on the amount type
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
