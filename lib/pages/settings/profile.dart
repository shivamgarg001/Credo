import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/state/global_variables.dart';
import '../../constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/add_contact/section_card.dart';
import '../../widgets/profile/select_image_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const id = '/profilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    // Access AppState to get values for clientName, phoneNumber, and password
    final appState = Provider.of<AppState>(context);
    
    // Initialize TextEditingControllers with the loaded values
    final clientNameController = TextEditingController(text: appState.clientName ?? '');
    final phoneController = TextEditingController(text: appState.phoneNumber ?? '');
    final passwordController = TextEditingController(text: appState.password ?? '');
    final addressController = TextEditingController(text: appState.address ?? '');
    final gstNumberController = TextEditingController(text: appState.gst ?? '');
    final businessNameController = TextEditingController(text: appState.businessname ?? '');

    // Disable phone number field
    phoneController.text = appState.phoneNumber ?? '';
    phoneController.selection = TextSelection.collapsed(offset: phoneController.text.length);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              children: [
                const CustomBackButton(title: 'Profile'),
                Hero(
                  tag: 'profile',
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 45.0,
                            backgroundImage: appState.profileImagePath != null
                                ? FileImage(File(appState.profileImagePath!))
                                : const AssetImage('assets/images/user.png') as ImageProvider,
                      ),
                      Positioned(
                        right: -3,
                        child: GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                const SelectImageBottomSheet(),
                          ),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                SectionCard(
                  children: [
                    CustomTextField(
                      controller: clientNameController,
                      hintText: 'Client Name',
                      prefixIcon: Icons.person,
                      label: 'Client Name*',
                      textInputType: TextInputType.name,
                      maxLength: 50,
                    ),
                    CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone,
                      label: 'Phone Number* (Read-only)',
                      textInputType: TextInputType.phone,
                      maxLength: 15,
                      enabled: false,
                      // enabled: false, // Disable the phone number field
                    ),
                    
                    CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      label: 'Password*',
                      textInputType: TextInputType.visiblePassword,
                      maxLength: 50,
                      obscureText: _isPasswordObscured,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordObscured = !_isPasswordObscured;
                          });
                        },
                      ),

                      // enabled: false,
                    ),
                    CustomTextField(
                      controller: addressController,
                      hintText: 'Address',
                      prefixIcon: Icons.location_on,
                      label: 'Address',
                      textInputType: TextInputType.text,
                      maxLength: 255,
                    ),
                    CustomTextField(
                      controller: gstNumberController,
                      hintText: 'GST Number',
                      prefixIcon: Icons.business,
                      label: 'GST Number',
                      textInputType: TextInputType.text,
                      maxLength: 15,
                    ),
                    CustomTextField(
                      controller: businessNameController,
                      hintText: 'Business Name',
                      prefixIcon: Icons.business_center,
                      label: 'Business Name',
                      textInputType: TextInputType.text,
                      maxLength: 50,
                    ),

                  ],
                ),
                CustomButton(
                  onTap: () {
                    setState(() {
                      isLoading=true;
                    });
                    // Trigger the API call here
                    _updateProfile(
                      context,
                      clientNameController.text,
                      phoneController.text,
                      passwordController.text,
                      addressController.text,
                      gstNumberController.text,
                      appState.clientId.toString(),
                      businessNameController.text,
                    );
                  },
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10.0),
                  title: isLoading ? 'Updating...': 'Update Profile',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to simulate API call for updating profile
  Future<void> _updateProfile(
    BuildContext context,
    String clientName,
    String phoneNumber,
    String password,
    String address,
    String gstNumber,
    String clientId,
    String businessName,
  ) async {
    
try {
    final updateResponse = await http.put(
      Uri.parse('https://credolabs.xyz/client/v1/updateclient/'),
      headers: {
        'Content-Type': 'application/json',
        'Client-ID': clientId,  
      },
      body: json.encode({
        'client_name': clientName,
        'phone_number': phoneNumber,  
        'password': password,
        'address': address,
        'gst_number': gstNumber,
        'business_name': businessName,
      }),
    );
    setState(() {
      isLoading = false; // Set loading to false after the API call completes
    });

    if (updateResponse.statusCode == 200) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setClientName(clientName);
      appState.setPhoneNumber(phoneNumber);
      appState.setPassword(password);
      appState.setAddress(address);
      appState.setGst(gstNumber);
      appState.setBusinessName(businessName);

      _showSuccessAnimation();
      await Future.delayed(Duration(milliseconds: 1000));  // Use a noticeable delay
      Navigator.of(context).pop();

    } else {
      _showErrorMessage("Failed to update profile. Please try again later.");
    }
  } catch (e) {
    print('Error in API call: $e');
    _showErrorMessage("An error occurred. Please try again.");
  }
    
  }
  
  void _showErrorMessage(String message) async{
    await _showFailureAnimation();
    await Future.delayed(Duration(milliseconds: 1000));  // Use a noticeable delay

    showErrorFlushbar(context, message);
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
    } 
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
    if(mounted){
      Navigator.of(context).pop();
    } // Close the dialog after delay
  }
  
  
}
