import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';
import '../../api/sendNotificationService.dart';
import '../../api/notificationService.dart';

class ChatsPage extends StatefulWidget {
  final List<Map<String, dynamic>> chats;
  final String chat_id;
  final String clientid;
  final String cust_suppid;
  final String type;
  final String ledgerid;
  final String phone_number;
  final String name;
  final String tag;

  const ChatsPage({
    super.key,
    required this.chats,
    required this.chat_id,
    required this.clientid,
    required this.cust_suppid,
    required this.type,
    required this.ledgerid, 
    required this.phone_number, 
    required this.name, 
    required this.tag,
  });

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAtBottom = true;
  String phoneNumber = "";

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

  Future<void> _sendPushNotification(String phoneNo, String title, String body,
      Map<String, dynamic> data) async {
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

  void _sendMessage(String message) async {
    if (message.isEmpty) return;
    print(message);

    // Prepare the payload for the API request
    final payload = {
      "sender_id": widget.clientid,
      "receiver_id": widget.cust_suppid,
      "status": 0,
      "message": {"msg": message},
      "messageType": 0, // AutoSizeText message type
      "created_at": DateTime.now().toString(),
    };

    final String apiUrl = 'https://credolabs.xyz/client/v1/chat/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Chat-ID': widget.chat_id,
          'Ledger-ID':widget.ledgerid,
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        _messageController.clear();
        _scrollToBottom();
        // _sendPushNotification(widget.phone_number, "💬 $message", "💬 ${widget.name} Sent A Message", {"💬 ${widget.name} Sent A Message":"${widget.name} Sent A Message"});

        // UNCOMMENT FOR SENDING THE MESSAGE TO SELF ALSO
        // _sendPushNotification(phoneNumber, "sent", "sent",{ "sent":"sent"});
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              
              widget.chats.add({
                "sender_id": widget.clientid,
                "receiver_id": widget.cust_suppid,
                "status": 0,
                "message": {"msg": message},
                "messageType": 0,
                "created_at": DateTime.now().toString(),
              });
            });
          }
        });
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    print(widget.chats);
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    phoneNumber = appState.phoneNumber.toString();
    // _setupFirebase();
    // _initializeNotifications();
    _scrollController.addListener(() {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _isAtBottom = _scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent;
          });
        }
      });
    });

    // Ensure scroll to bottom after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(); // Scroll to the bottom after the first build
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool disableUpdates = false;
    Map<String, dynamic>? latestUpdateMessage;
    for (var chat in widget.chats.reversed) {
      if (chat['messageType'] == 1) {
        latestUpdateMessage = chat;
        break;
      } else if (chat['messageType'] == 2) {
        disableUpdates = true;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(S.of(context).chats,
            style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Color(0xFF075E54), // WhatsApp Green
        actions: disableUpdates
            ? [] // If updates are disabled, don't show the actions
            : [
                IconButton(
                  icon: Icon(Icons.update),
                  onPressed: _showUpdateDialog,
                ),
              ],
      ),
      backgroundColor: Color(0xFFF3E4D3), // Light blue background
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/whatsapp_bg.png'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.chats.length,
                  itemBuilder: (context, index) {
                    final chat = widget.chats[index];
                    bool isSender = chat['sender_id'] == widget.clientid;

                    // If it's an update message (messageType == 1), we want to display it more aesthetically
                    final message = chat['message']["msg"];
                    String displayMessage = '';

                    if (message is Map) {
                      // If the message is an update (contains description, rate, quantity, amount)
                      final description = message['description'] ?? 'No description';
                      final rate = message['rate'] ?? 0.0;
                      final quantity = message['quantity'] ?? 0.0;
                      dynamic amount = message['amount'] ?? 0.0;

                      if(widget.tag=='S') amount=-amount;

                      displayMessage = (widget.tag == 'S') 
                      ? 
                      '''
                        Description: $description
                        Amount: ₹${amount.toStringAsFixed(2)}
                      ''' 
                      : 
                      '''
                        Description: $description
                        Rate: ₹${rate.toStringAsFixed(2)}
                        Quantity: $quantity
                        Amount: ₹${amount.toStringAsFixed(2)}
                      ''' ;
                    } else {
                      // If it's a simple text message
                      displayMessage = message ?? 'No message';
                    }

                    // Check if this is the latest update message and should show the approve button
                    bool showApproveButton = latestUpdateMessage != null &&
                        chat == latestUpdateMessage &&
                        chat['sender_id'] != widget.clientid;

                    // Check if messageType is 2 and should display APPROVED TICK
                    bool isApproved = chat['messageType'] == 2;

                    // print(chat['created_at']);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: isSender
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSender ? Color(0xFFDCF8C6) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3, color: Colors.grey.shade400)
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                displayMessage,
                                style: TextStyle(
                                  color: isSender ? Colors.black : Colors.black,
                                  fontFamily: 'SF-Pro',
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              AutoSizeText(
                              chat['created_at'] != null
                                  ? (() {
                                      // Parse the 'created_at' to DateTime
                                      DateTime chatDate = DateTime.parse(chat['created_at']);
                                      
                                      // If index is less than 2, adjust by adding 5 hours and 30 minutes
                                      if (index < 2) {
                                        chatDate = chatDate.add(Duration(hours: 5, minutes: 30));
                                      }

                                      // Format the date to the desired format
                                      return '${chatDate.hour.toString().padLeft(2, '0')}:${chatDate.minute.toString().padLeft(2, '0')} ${chatDate.day.toString().padLeft(2, '0')}/${chatDate.month.toString().padLeft(2, '0')}/${chatDate.year.toString().substring(2)}';
                                    })()
                                  : S.of(context).no_timestamp_available,
                                style: TextStyle(
                                    fontFamily: 'SF-Pro',
                                    fontSize: 10,
                                    color: Colors.black),
                              ),
                              // Show the Approve button for the latest messageType == 1 and if sender is not clientid
                              if (showApproveButton)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _approveMessage(chat);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Color(0xFF075E54), // AutoSizeText color
                                    ),
                                    child: AutoSizeText(S.of(context).approve,                               overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
                                  ),
                                ),
                              // Show the APPROVED TICK if messageType == 2
                              if (isApproved)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                        size: 40,
                                      ),
                                      SizedBox(width: 5),
                                      AutoSizeText(
                                        S.of(context).approved,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 255),
                                            fontFamily: 'SF-Pro',
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (!_isAtBottom)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: _scrollToBottom,
                      backgroundColor: Color(0xFF075E54),
                      child: Icon(Icons.arrow_downward), // WhatsApp Green
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 8.0), // Adjusted vertical padding
              child: Row(
                children: [
                  // TextField for message input
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.black54),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                        ),
                      ),
                    ),
                  ),

                  // Send Button with rounded corners
                  SizedBox(width: 10), // Space between the TextField and Send button
                  GestureDetector(
                    onTap: () {
                      _sendMessage(_messageController.text);
                      _messageController.clear(); // Optionally clear the message field
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF075E54), // WhatsApp Green
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _approveMessage(Map<String, dynamic> chat) async {
    print('Message Approved: ${chat['message']["msg"]}');

    // Step 1: Make the POST request to send the message
    final updateMessage = chat['message']["msg"];
    final payload = {
      "sender_id": widget.clientid,
      "receiver_id": widget.cust_suppid,
      "status": 1,
      "message": {'msg': updateMessage},
      "messageType": 2, // AutoSizeText message type
      "created_at": DateTime.now().toString(),
    };

    final String apiUrl = 'https://credolabs.xyz/client/v1/chat/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Chat-ID': widget.chat_id,
          'Ledger-ID':widget.ledgerid,

        },
        body: json.encode(payload),
      );

      // If POST request is successful, proceed to the PUT request
      if (response.statusCode == 200) {
                _messageController.clear();
        _scrollToBottom();
        // _sendPushNotification(
        //   widget.phone_number,
        //   "✅ ${widget.name} Approved The Invoice",
        //   "📝 Description - ${updateMessage["description"]} | 💰 Amount - ${updateMessage["amount"]}}",
        //   {"${widget.name} Approved The Invoice": "${widget.name} Approved The Invoice"});
                        
        // await _sendPushNotification(phoneNumber.toString(), "Approved Invoice", "Approved Invoice", {"Approved Invoice": "Approved Invoice"});
        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              widget.chats.add({
                "sender_id": widget.clientid,
                "receiver_id": widget.cust_suppid,
                "status": 1,
                "message": {"msg": updateMessage},
                "messageType": 2,
                "created_at": DateTime.now().toString(),
              });
            });
          }
        });
        // Proceed with the PUT request to approve the message
        String updateApiUrl =
            'https://credolabs.xyz/client/v1/supplier/invoice/update/';
        if (widget.type == 'customer_credit') {
          updateApiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/update/';
        }

        final putResponse = await http.put(
          Uri.parse(updateApiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Client-ID': widget.clientid,
            'Customer-ID': widget.cust_suppid,
            'Supplier-ID': widget.cust_suppid,
            'Ledger-ID': widget.ledgerid,
            'Chat-ID': widget.chat_id,
          },
          body: json.encode({
            'description': updateMessage['description'],
            'quantity': updateMessage['quantity'],
            'rate': updateMessage['rate'],
          }),
        );

        // Handle the PUT request response
        if (putResponse.statusCode == 200) {
          if (mounted) {
            Navigator.pop(context, true);
          }
          showSuccessFlushbar(context, 'Invoice Approved successfully');
        } else if (response.statusCode == 404) {
          _showErrorMessage('Enter correct details/Some Error Occured');
        } else {
          _showErrorMessage('Failed to update invoice');
        }
      } else {
        // Handle POST request failure
        _showErrorMessage(
            'Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      _showErrorMessage('Error: $e');
    }
  }

  void _showErrorMessage(String message) async {
    await _showFailureAnimation();
    await Future.delayed(
        Duration(milliseconds: 1000)); // Use a noticeable delay

    showErrorFlushbar(context, message);
  }

  void _showUpdateDialog() {
    final descriptionController = TextEditingController();
    final rateController = TextEditingController();
    final quantityController = TextEditingController();

    String quantityAmountText = (widget.tag=="S") ? "Amount" : S.of(context).quantity;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      bool isUpdating = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: SafeArea(
              child: AutoSizeText(
                S.of(context).update_item,
                maxLines: 2,
                minFontSize: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: S.of(context).description),
                ),
                if (widget.tag == "C") ...[
                  TextField(
                    controller: rateController,
                    decoration: InputDecoration(labelText: S.of(context).rate),
                    keyboardType: TextInputType.number,
                  ),
                ],
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: quantityAmountText),
                  keyboardType: TextInputType.number,
                ),
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
                    maxLines: 1,
                    minFontSize: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TextButton(
                onPressed: isUpdating
                    ? null
                    : () async {
                        setState(() => isUpdating = true);

                        final description = descriptionController.text;
                        final rate = double.tryParse(rateController.text) ?? -1.0;
                        final quantity = double.tryParse(quantityController.text) ?? 0.0;

                        final updateMessage = {
                          "description": description,
                          "rate": rate,
                          "quantity": quantity,
                          "amount": rate * quantity
                        };
                        final payload = {
                          "sender_id": widget.clientid,
                          "receiver_id": widget.cust_suppid,
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
                              'Chat-ID': widget.chat_id,
                              'Ledger-ID': widget.ledgerid,
                            },
                            body: json.encode(payload),
                          );

                          if (response.statusCode == 200) {
                            _messageController.clear();
                            _scrollToBottom();

                            Future.delayed(Duration.zero, () {
                              if (mounted) {
                                setState(() {
                                  widget.chats.add({
                                    "sender_id": widget.clientid,
                                    "receiver_id": widget.cust_suppid,
                                    "status": 0,
                                    "message": {"msg": updateMessage},
                                    "messageType": 1,
                                    "created_at": DateTime.now().toString(),
                                  });
                                });
                              }
                            });
                          } else {
                            _showErrorMessage('Failed to send message');
                          }
                        } catch (e) {
                          print('Error: $e');
                        }

                        if (mounted) Navigator.of(context).pop();
                        setState(() => isUpdating = false);
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
                          maxLines: 1,
                          minFontSize: 5,
                          overflow: TextOverflow.ellipsis,
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


}
