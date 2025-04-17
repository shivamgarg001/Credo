
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; 
 
import 'dart:convert';
import 'dart:io';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/api/notificationService.dart';
import 'package:credo/api/sendNotificationService.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';

class SendMoney extends StatefulWidget {
  final String clientid, customerid, ledgerid, type, name, phone_number;

  const SendMoney({
    super.key,
    required this.clientid,
    required this.customerid,
    required this.ledgerid,
    required this.type, required this.name, required this.phone_number,
  });

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final picker = ImagePicker();
  List<XFile>? images;
  bool uploading = false;
  String cloudinary_url = "http://www.google.com/";
  String phoneNumber = "";

  // Input controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  
  double calculatedAmount = 0.0;
  
  bool isLoading = false;
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
    Navigator.of(context).pop(); // Close the dialog after delay
  }

  Future<void>  _showFailureAnimation() async {
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

    await Future.delayed(const Duration(milliseconds: 800)); // Wait for animation to complete
    Navigator.of(context).pop(); // Close the dialog after delay
  }
  
  void _showErrorMessage(String message) async{
    await _showFailureAnimation();
        await Future.delayed(Duration(milliseconds: 1000));  // Use a noticeable delay

    showErrorFlushbar(context, message);
  }
  
  void calculateAmount() {
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    Future.delayed(Duration.zero, () {
      if(mounted){
        setState(() {
          calculatedAmount = -quantity;
        });
      }
    });
  }

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if(mounted){
          setState(() {
            images = pickedFiles;
          });
        }
      });
    }
  }


  Future<void> submitFinalData() async {
    final bodyData = json.encode({
      'description': descriptionController.text,
      'quantity': double.tryParse(quantityController.text) ?? 0.0,
      'rate': -1.0,
      'amount': calculatedAmount,
      'tag':'S'
    });

    String apiUrl = 'https://credo.up.railway.app/client/v1/customer/invoice/add/';
    if (widget.type == "customer_notif") {
      apiUrl = 'https://credo.up.railway.app/client/v1/supplier/invoice/add/';
    }
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Client-ID': widget.clientid,
        'Customer-ID': widget.customerid,
        'Supplier-ID': widget.customerid,
        'Ledger-ID': widget.ledgerid,
        'Cloudinary-URL': cloudinary_url,
        'Type': widget.type,
      },
      body: bodyData,
    );

    if (response.statusCode == 200) {
      
      await _showSuccessAnimation();
      if(mounted){
        Navigator.pop(context, true); 
      }
      // await _sendPushNotification(phoneNumber.toString(), "Money Sent", "$quantityController Money Sent", {"$quantityController Money Sent":"$quantityController Money Sent"});
      // await _sendPushNotification(widget.phone_number, "💰 ₹${quantityController.text} Received", "💰 ₹${quantityController.text} Received From ${widget.name}", {"₹${quantityController.text} Received From ${widget.name}":"₹${quantityController.text} Received From ${widget.name}"});
      
    }
    else if(response.statusCode==400){
      _showErrorMessage("Please enter correct details!");
    } 
    else {
      _showErrorMessage("Failed to submit receipt!");
    }
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
  
  Future<void> captureImage() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            images = [...?images, photo];  // Append new image while keeping previous ones
          });
        }
      });
    }
  }


  @override
  void initState(){
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    phoneNumber = appState.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          S.of(context).sendMoney,
          maxLines: 2, // Max of 2 lines
          minFontSize: 5, // Minimum font size
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Upper Half - Image & Audio Upload
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.upload_file),
                    label: AutoSizeText(
                      S.of(context).upload_receipt_photos,
                      maxLines: 2, // Max of 2 lines
                      minFontSize: 5, // Minimum font size
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: pickImages,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: AutoSizeText(
                      S.of(context).takePhoto,
                      maxLines: 2, // Max of 2 lines
                      minFontSize: 5, // Minimum font size
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: captureImage, // Function to open the camera
                  ),
                ),
              ],
            ),
            if (images != null && images!.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: images!.map(
                            (img) => Padding(
                              padding: EdgeInsets.all(4),
                              child: Image.file(File(img.path), width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),

            Divider(height: 30),

            // Lower Half - Input Fields
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Remarks',
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    onChanged: (_) => calculateAmount(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Money'),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      await submitFinalData();
                      setState(() => isLoading = false);
                    },
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : AutoSizeText(
                      S.of(context).sendMoney,
                      maxLines: 2,
                      minFontSize: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}