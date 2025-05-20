import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/api/notificationService.dart';
import 'package:credo/api/sendNotificationService.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';
import 'dart:convert';
import 'chats_page.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> transactionData;
  final String clientid;
  final String customerid;
  final String ledgerid;
  final String type;
  final String name;
  final String phone_number;
  final String tag;
  final bool side;
  // side = 0 -> customer side
  // side = 1 -> supplier side

  const TransactionDetailPage(
      {super.key,
      required this.transactionData,
      required this.clientid,
      required this.customerid,
      required this.ledgerid,
      required this.type,
      required this.side, 
      required this.phone_number, required this.name, required this.tag});

  @override
  _TransactionDetailPageState createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  bool isLoading = false;
  List<dynamic> moreDetails = [];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  String phoneNumber = "";
  
  bool isDeleting = false;
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    phoneNumber = appState.phoneNumber.toString();
    // Automatically call _getMoreDetails when the page is loaded
    _getMoreDetails(widget.transactionData['chat_id']);
  }
  Future<void> _sendPushNotification(String phoneNo, String title, String body, Map<String, dynamic> data) async {
    if (phoneNo.isEmpty) {
    print("Error: Cannot send notification, phone number is empty.");
    return;
  }

    NotificationService notificationService = NotificationService();
    
    String? token = await notificationService.fetchTokenForPhoneNo(phoneNo);

    if (token != null) {
      await SendNotificationService.sendNotificationUsingApi(
        token: token,
        title: title,
        body: body,
        data: data,
      );
    } else {
      print("No FCM token found for phone number: $phoneNo");
    }
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

  // Fetch more transaction details when "Get More Details" is pressed
  Future<void> _getMoreDetails(String chatId) async {
    final type = widget.type;
    String apiUrl = 'https://credolabs.xyz/client/v1/supplier/invoice/get/';

    if (type == "customer_credit" || type == "supplier_notif") {
      apiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/get/';
    }
    try {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      });

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid,
          'Chat-ID': chatId,
        },
      );

      if (response.statusCode == 200) {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              moreDetails = json.decode(response.body);
              isLoading = false;
            });
          }
        });
      } else {
        _showErrorMessage('Failed to load more details');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
      
    }
  }

  void _viewChats() async {
    List<Map<String, dynamic>> chats = [];

    final type = widget.type;
    String apiUrl = 'https://credolabs.xyz/client/v1/supplier/invoice/get/';

    if (type == "customer_credit") {
      apiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/get/';
    }
    try {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
      });
      print(widget.ledgerid);
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid,
          'Chat-ID': widget.transactionData["chat_id"],
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          moreDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorMessage('Failed to load more details');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
      Future.delayed(Duration.zero, () {
        if (mounted) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          });
        }
      });
      
    }

    if (moreDetails.isNotEmpty) {
      if (moreDetails.length > 1 && moreDetails[1]['chats'] != null) {
        chats = List<Map<String, dynamic>>.from(moreDetails[1]['chats']);
      }
    }
    print(widget.clientid);
    print(widget.customerid);
    print("CHATS ARE ////////////////////// $chats");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatsPage(
            chats: chats,
            chat_id: widget.transactionData["chat_id"],
            clientid: widget.clientid,
            cust_suppid: widget.customerid,
            type: widget.type,
            ledgerid: widget.ledgerid,
            phone_number:widget.phone_number.toString(),
            name : widget.name,
            tag: widget.tag,
            ),
      ),
    ).then((result) async {
      if (result == true) {
        await _getMoreDetails(widget.transactionData['chat_id']);
      }
    });
  }

  // Show error message
  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    showErrorFlushbar(context, message);
  }

  // Delete Invoice
  Future<void> _deleteInvoice() async {
    String apiUrl =
        'https://credolabs.xyz/client/v1/supplier/invoice/delete/';
    if (widget.type == 'customer_credit') {
      apiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/delete/';
    }
    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid,
          'Chat-ID': widget.transactionData['chat_id'],
        },
      );

      if (response.statusCode == 200) {
        await _showSuccessAnimation();
        if (mounted) {
          Navigator.pop(context, true);
        }
        // showSuccessFlushbar(context, 'Invoice deleted successfully');
      } else {
        _showErrorMessage('Failed to delete invoice');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  // Update Invoice
  Future<void> _updateInvoice() async {
    final description = descriptionController.text;
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final rate = double.tryParse(rateController.text) ?? 0.0;

    String apiUrl =
        'https://credolabs.xyz/client/v1/supplier/invoice/update/';
    if (widget.type == 'customer_credit' || widget.type == 'customer_debit') {
      apiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/update/';
    }
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Client-ID': widget.clientid,
          'Customer-ID': widget.customerid,
          'Supplier-ID': widget.customerid,
          'Ledger-ID': widget.ledgerid,
          'Chat-ID': widget.transactionData['chat_id'],
        },
        body: json.encode({
          'description': description.toString(),
          'quantity': quantity,
          'rate': rate,
        }),
      );

      if (response.statusCode == 200) {
        await _showSuccessAnimation();
        if (mounted) {
          Navigator.pop(context, true);
        }
        double amount = rate*quantity;

        // _sendPushNotification(
        //   widget.phone_number,
        //   "✅ ${widget.name} Updated The Invoice",
        //   "📝 Description - $description | 💰 Amount - $amount}",
        //   {"✅ ${widget.name} Updated The Invoice": "✅ ${widget.name} Updated The Invoice"});

        // showSuccessFlushbar(context, 'Invoice updated successfully');
        final updateMessage = {
          "description": description.toString(),
          "rate": rate,
          "quantity": quantity,
          "amount": rate * quantity
        };
        final payload = {
          "sender_id": widget.clientid,
          "receiver_id": widget.customerid,
          "status": 0,
          "message": {'msg': updateMessage},
          "messageType": 1, 
          "created_at": DateTime.now().toString(),
        };

        final String apiUrl = 'https://credolabs.xyz/client/v1/chat/';

        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Chat-ID': widget.transactionData['chat_id'],
              'Ledger-ID':widget.ledgerid,
            },
            body: json.encode(payload),
          );

          if (response.statusCode == 200) {
            // showSuccessFlushbar(context, "Message Sent");
          } else {
            _showErrorMessage('Failed to send message');
          }
        } catch (e) {
          print('Error: $e');
        }
      } else {
        _showErrorMessage('Failed to update invoice');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    }
  }

  void _showUpdateDialog() {
    // Ensure that we are getting the correct data type
    descriptionController.text = widget.transactionData['description'] is String
        ? widget.transactionData['description']
        : widget.transactionData['description'] is List 
            ? widget.transactionData['description'][0] 
            : ''; 

    quantityController.text = widget.transactionData['quantity'] is num
        ? widget.transactionData['quantity'].toString()
        : ''; // Default to empty string if it's not a number

    // Set rate to -1.0 automatically if widget.tag is 'S'
    // Otherwise, use the existing rate value
    if (widget.tag == 'S') {
      rateController.text = '-1.0'; 
    } else {
      rateController.text = widget.transactionData['rate'] is num
          ? widget.transactionData['rate'].toString()
          : ''; 
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isUpdating = false; // Local dialog state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: SafeArea(
                child: AutoSizeText(
                  S.of(context).update_invoice,
                  maxLines: 2,
                  minFontSize: 5,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: S.of(context).description),
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: S.of(context).quantity),
                    keyboardType: TextInputType.number,
                  ),
                  if (widget.tag == 'C') ...[
                    TextField(
                      controller: rateController,
                      decoration: InputDecoration(labelText: S.of(context).rate),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SafeArea(
                    child: AutoSizeText(
                      S.of(context).cancel,
                      maxLines: 2,
                      minFontSize: 5,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () async {
                          setState(() => isUpdating = true);
                          await _updateInvoice();
                          await _getMoreDetails(widget.transactionData['chat_id']);
                          setState(() => isUpdating = false);
                          if (mounted) {
                            Navigator.pop(context, true);
                          }
                        },
                  child: isUpdating
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
                            S.of(context).update,
                            maxLines: 2,
                            minFontSize: 5,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );

  }

  // Full-screen Image Viewer
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: InteractiveViewer(
                panEnabled: true, // Allows panning
                boundaryMargin:
                    EdgeInsets.all(50), // Adds padding around the image
                minScale: 0.1, // Minimum zoom scale
                maxScale: 4.0, // Maximum zoom scale
                child: Image.network(imageUrl),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transactionData;
    List<String> imageLinks = [];

    // Check if moreDetails is not empty and contains valid data
    if (moreDetails.isNotEmpty &&
        moreDetails.length > 1 &&
        moreDetails[1]['user_data'] != null) {
      String userData = moreDetails[1]['user_data'];

      if (userData.startsWith('[') && userData.endsWith(']')) {
        userData =
            userData.substring(1, userData.length - 1); // Remove the brackets
      }
      imageLinks = userData.split(',').map((e) => e.trim()).toList();
    }

    // Initialize istTime with the current time to avoid null issues
    DateTime istTime = DateTime.now();

    // Handle `moreDetails` and `transaction` for parsing `istTime`
    if (!widget.side) {
      if (moreDetails.isNotEmpty && moreDetails[0]['created_at'] != null) {
        try {
          istTime = DateTime.parse(moreDetails[0]['created_at'])
              .toUtc()
              .add(Duration(hours: 11, minutes: 00));
        } catch (e) {
          print("Error parsing 'updated_at': $e");
        }
      } else {
        print("moreDetails is empty or 'updated_at' is missing");
      }
    } else {
      if (transaction.containsKey('created_at') &&
          transaction['created_at'] != null) {
        try {
          istTime = DateTime.parse(transaction['created_at'])
              .toUtc()
              .add(Duration(hours: 11, minutes: 00));
        } catch (e) {
          print("Error parsing 'created_at': $e");
        }
      } else {
        print("transaction or 'created_at' is null");
      }
    }
  bool showUpdateDeleteButtons = !(
    (widget.tag == 'S' && widget.type.contains("credit")) || 
    (widget.tag == 'C' && widget.type.contains("notif")) || 
    (moreDetails.length > 1 && moreDetails[1]["status"] == 1)
  );

  // Handle the text change for the buttons if widget.tag == 'S' and widget.type contains "notif"
  String deleteButtonText = (widget.tag == 'S' && widget.type.contains("notif")) 
    ? "Delete Payment" 
    : S.of(context).delete_invoice;

  String updateButtonText = (widget.tag == 'S' && widget.type.contains("notif")) 
    ? "Update Payment" 
    : S.of(context).update_invoice;
  
  dynamic amountValue = moreDetails.isNotEmpty ? moreDetails[0]['amount'] : null;
  double amount = 0;

  if (amountValue != null) {
    if (amountValue is double) {
      amount = amountValue;
    } else if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0;
    }
  }

  if (widget.tag == 'S')  amount = -amount; 

  // Handle the description when it is a list
  String description = 'N/A';
  if (moreDetails.isNotEmpty && moreDetails[0]['description'] != null) {
    var desc = moreDetails[0]['description'];
    if (desc is List) {
      description = desc.isNotEmpty ? desc[0] : 'N/A'; // Show the first element if it's a list
    } else {
      description = desc ?? 'N/A'; // Show the description directly if it's not a list
    }
  }
  print(imageLinks);

// Build the UI
return Scaffold(
  backgroundColor: Colors.grey[50],
  appBar: AppBar(
    elevation: 0,
    title: Text(
      S.of(context).transaction_details,
      style: TextStyle(
        fontSize: 18, 
        fontWeight: FontWeight.w500, 
        color: Colors.white,
      ),
    ),
    backgroundColor: Color(0xFF2E7D32),
    actions: [
      if (showUpdateDeleteButtons)
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setDialogState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(S.of(context).delete_invoice_confirmation),
                      content: Text(S.of(context).delete_invoice_warning),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            S.of(context).cancel,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        TextButton(
                          onPressed: isDeleting
                              ? null
                              : () async {
                                  setDialogState(() => isDeleting = true);
                                  await _deleteInvoice();
                                  setDialogState(() => isDeleting = false);
                                  if (mounted) {
                                    Navigator.pop(context, true);
                                  }
                                },
                          child: isDeleting
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                  ),
                                )
                              : Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
    ],

  ),
  body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Amount (First)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).amount,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹ $amount',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // 2. Rate and Quantity
            if (widget.tag != 'S')
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).rate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '₹${moreDetails.isNotEmpty ? moreDetails[0]['rate'] ?? '0' : '0'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey[200],
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).quantity,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${moreDetails.isNotEmpty ? moreDetails[0]['quantity'] ?? '0' : '0'}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            if (widget.tag != 'S') SizedBox(height: 24),
            
            // 3. Description
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // 4. Status and Date
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          color: moreDetails.length > 1 && moreDetails[1]["status"] == 0
                              ? Color(0xFFFFF3E0)
                              : Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          moreDetails.length > 1 && moreDetails[1]["status"] == 0
                              ? S.of(context).pending
                              : S.of(context).approved,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: moreDetails.length > 1 && moreDetails[1]["status"] == 0
                                ? Color(0xFFEF6C00)
                                : Color(0xFF2E7D32),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    S.of(context).date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${istTime.hour.toString().padLeft(2, '0')}:${istTime.minute.toString().padLeft(2, '0')} ${istTime.day.toString().padLeft(2, '0')}/${istTime.month.toString().padLeft(2, '0')}/${istTime.year.toString().substring(2)}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Images (if available)
            if (imageLinks.isNotEmpty) ...[
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).image,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    if (imageLinks.any((link) => link.contains('google.com')))
                      Text(
                        S.of(context).no_image_captured,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600])
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1,
                        ),
                        itemCount: imageLinks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showFullScreenImage(context, imageLinks[index].trim());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageLinks[index].trim(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
            
            SizedBox(height: 150), // Space for floating buttons
          ],
        ),
      ),
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  floatingActionButton: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showUpdateDeleteButtons)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              icon: Icon(Icons.edit_outlined, size: 18, color: Colors.white),
              onPressed: _showUpdateDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF9800),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              label: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      S.of(context).update_invoice,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        
        SizedBox(height: 12),
        // View Chats Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: Icon(Icons.chat_outlined, size: 18, color: Colors.white),
            onPressed: _viewChats,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E7D32),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            label: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    S.of(context).view_chats,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    ),
  ),
);
  }
}