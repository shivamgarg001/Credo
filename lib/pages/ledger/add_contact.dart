

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart'; 
import 'dart:convert';
import '../../constants.dart';
import '../../model/data.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/add_contact/section_card.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

class AddContactPage extends StatefulWidget {
  final String clientid;
  const AddContactPage({super.key, required this.clientid});

  static const id = '/addContactPage';

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = true;
  bool _isLoading = false;
  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();
  
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
  
  Future<void> _submitPhoneNumber(String type) async {
    final phoneNumber = _phoneController.text.trim();

    // Validate phone number length
    if (phoneNumber.length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      Future.delayed(Duration.zero, (){
        if(mounted){
          setState(() {
            _isPhoneValid = false;
          });
        }
      });
      return;
    }

    Future.delayed(Duration.zero, (){
        if(mounted){
          setState(() {
            _isLoading = true;
            _isPhoneValid = true;
          });
        }
    });
    

    try {
      // First API call
      final int? response1 = await _callFirstApi(phoneNumber);

      if (response1 != null) {
        // Second API call using the response from the first API
        final response2 = await _callSecondApi(response1, type);

        if (response2 != null) {
          // add anything here 
          final player = AudioPlayer();
          await player.play(AssetSource('sounds/success.mp3'));
          await _showSuccessAnimation();
          showSuccessFlushbar(context, '$type added successfully!');
          // Navigator.pop(context, true);
        }
        else{
          // Navigator.pop(context, false);
        } 
      }
    } catch (e) {
      showErrorFlushbar(context, 'Error: $e');
      // Navigator.pop(context, false);
    } finally {
      Future.delayed(Duration.zero, (){
        if(mounted){
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
  
  void _showErrorMessage(String message) async{
    await _showFailureAnimation();
        await Future.delayed(Duration(milliseconds: 1000));  // Use a noticeable delay

    showErrorFlushbar(context, message);
  }
  
  Future<int?> _callFirstApi(String phoneNumber) async {
    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://credo.up.railway.app/client/v1/get_id_from_phone_no/'),
        headers: {'Phone': phoneNumber},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data.containsKey('client_id')) {
          return data['client_id'];
        } else {
          throw Exception('id not found in response');
        }
      } else if (response.statusCode == 400) {
        _showErrorMessage("Please enter Phone Number correctly!");
        throw Exception('Please enter Phone Number correctly!');
      } else {
        _showErrorMessage("This Person is not on our App, Please Invite... 😊");
        throw Exception('This Person is not on our App, Please Invite... 😊');
      }
    } catch (e) {
      print('Error in first API call: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _callSecondApi (int id, String type) async {
    String apiUrl = 'https://credo.up.railway.app/client/v1/supplier/add/';
    if (type == "Customer") {
      apiUrl = 'https://credo.up.railway.app/client/v1/customer/add/';
    }

    try {
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Client-ID": widget.clientid},
        body: {"id":id.toString()},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } 
      else if(response.statusCode==400){
        _showErrorMessage("Please enter Phone Number correctly!");
        throw Exception('Failed to process contact');
      }
      else if(response.statusCode==204){
        _showErrorMessage("Already Added the $type!");
        throw Exception('Already Added the $type!');
      }
      else if(response.statusCode==409){
        _showErrorMessage("Please do not enter your Phone Number!");
        throw Exception('Please do not enter your Phone Number!');
      }
      else{
        _showErrorMessage("This user is not our platform. Please invite!");
        throw Exception('This user is not our platform. Please invite');
      }
    } catch (e) {
      print('Error in second API call: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Consumer<DataModel>(
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                     CustomBackButton(title: S.of(context).add_contact),
                    CustomButton(
                      onTap: () async {
                        final FlutterNativeContactPicker contactPicker = FlutterNativeContactPicker();
                        Contact? contact = await contactPicker.selectPhoneNumber();

                        if (contact != null) {
                          // Extract the selected phone number
                          String? selectedPhoneNumber = contact.selectedPhoneNumber;

                          if (selectedPhoneNumber != null) {
                            final String cleanedPhoneNumber = selectedPhoneNumber
                            .replaceAll('+91', '')
                            .replaceAll(RegExp(r'[^\d]'), '');

                            Future.delayed(Duration.zero, (){
                              if(mounted){
                                setState(() {
                                  _phoneController.text = cleanedPhoneNumber;
                                });
                              }
                            });


                            // Validate the phone number length (10 digits)
                            if (cleanedPhoneNumber.length == 10) {
                              // You can call the first API with the selected phone number directly
                              // await _submitPhoneNumber(value.selectedCustomerCategory);
                            } else {
                              print('Invalid phone number length');
                            }
                          }
                        }
                      },
                      icon: Icons.contacts,
                      title: 'Select Contact',
                    ),

                    const SizedBox(height: 25.0),
                    Row(
                      children: [
                        CustomDivider(),
                        AutoSizeText(
                          // 'OR',
                                                        overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

                          S.of(context).or,
                          style: TextStyle(
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomDivider(),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    SectionCard(
                      children: [
                        AutoSizeText(
                                                        overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

                          // 'Select Category',
                          S.of(context).select_category,
                          style: kSectionHeaderStyle,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: 'Customer',
                                title: AutoSizeText(S.of(context).customer,                               
                                overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
                                contentPadding: const EdgeInsets.all(0),
                                groupValue: value.selectedCustomerCategory,
                                onChanged: (p0) =>
                                    value.updateCustomerCategory(p0),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                // title: const AutoSizeText('Supplier'),
                                value: 'Supplier',
                                title: AutoSizeText(S.of(context).supplier,                               
                                overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
                                groupValue: value.selectedCustomerCategory,
                                onChanged: (p0) =>
                                    value.updateCustomerCategory(p0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SectionCard(
                      children: [
                        AutoSizeText(
                                                        overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

                          // '${value.selectedCustomerCategory} Details',
                          '${value.selectedCustomerCategory} ${S.of(context).details}',
                          style: kSectionHeaderStyle,
                        ),
                        const SizedBox(height: 15.0),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'XXXXXXXXXX',
                          prefixIcon: Icons.call,
                          label: 'Phone Number*',
                          textInputType: TextInputType.number,
                          maxLength: 10,
                          errorText: !_isPhoneValid
                              ? 'Enter a valid phone number'
                              : null,
                        ),
                      ],
                    ),
                    CustomButton(
                      onTap: () {
                        if (!_isLoading) {
                          _submitPhoneNumber(value.selectedCustomerCategory);
                        }
                      },
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10.0),
                      title: _isLoading ? 'Submitting...' : 'Confirm',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}