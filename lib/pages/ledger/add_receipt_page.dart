import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:credo/api/notificationService.dart';
import 'package:credo/api/sendNotificationService.dart';
import 'package:credo/flushbar_helper.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class AddReceiptPage extends StatefulWidget {
  final String clientid, customerid, ledgerid, type, phone_number, name;

  const AddReceiptPage({
    super.key,
    required this.clientid,
    required this.customerid,
    required this.ledgerid,
    required this.type, 
    required this.phone_number, required this.name,
  });

  @override
  _AddReceiptPageState createState() => _AddReceiptPageState();
}

class _AddReceiptPageState extends State<AddReceiptPage> {
  final picker = ImagePicker();
  List<XFile>? images;
  bool uploading = false;
  String cloudinary_url = "http://www.google.com/";
  String phoneNumber = "";
  bool isLoading = false;
  // Audio Recorder variables
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _recordedAudioPath;
  bool _isRecording = false;
  final bool _isAudioRecorded = false;
  bool _isPlaying = false;
  bool audioRecorded = false; // Track if audio is recorded
  XFile? recordedAudio; // Store the recorded audio
  

  
  // Input controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  double calculatedAmount = 0.0;
  
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    phoneNumber = appState.phoneNumber.toString();
    _checkPermissions();
    _audioPlayer.onPlayerComplete.listen((event){
      setState(() {
        _isPlaying=false;
      });
    });
  }

  // Audio Recorder Permission Check
  Future<void> _checkPermissions() async {
    final microphonePermission = await Permission.microphone.request();
    if (microphonePermission.isDenied) {
      print("Microphone permission denied!");
    }
  }

  Future<void> _playAudio() async {
    if (_recordedAudioPath != null) {
      File audioFile = File(_recordedAudioPath!);
      if (await audioFile.exists()) {
        await _audioPlayer.play(DeviceFileSource(_recordedAudioPath!));
        setState(() {
          _isPlaying = true;
        });
      } else {
        print("Error: Audio file not found.");
        setState(() {
          _isPlaying = false;
        });
      }
    } else {
      _showErrorMessage("No recorded audio available.");
      print("Error: No recorded audio available.");
    }
  }

  // Success and Failure Animation
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

  Future<void> _showFailureAnimation() async {
    showDialog(
      context: context,
      barrierDismissible: false, 
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

  // Error Message
  void _showErrorMessage(String message) async{
    await _showFailureAnimation();
    await Future.delayed(Duration(milliseconds: 1000));  // Use a noticeable delay
    showErrorFlushbar(context, message);
  }

  // Calculate Amount
  void calculateAmount() {
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final rate = double.tryParse(rateController.text) ?? 0.0;
    Future.delayed(Duration.zero, () {
      if(mounted){
        setState(() {
          calculatedAmount = quantity * rate;
        });
      }
    });
  }

  // Image Picker
  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        if(mounted){
          setState(() {
            images = pickedFiles;
            audioRecorded=false;
          });
        }
      });
    }
  }

  // Upload Images and Fetch Data
  Future<void> uploadImagesAndFetchData() async {
    Future.delayed(Duration.zero, () {
      if(mounted){
        setState(() => uploading = true);
      }
    });
    
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://credolabs.xyz/biz/v1/upload-image/'),
    );

    request.headers.addAll({
      'Client-ID': widget.clientid,
      'Customer-ID': widget.customerid,
      'Ledger-ID': widget.ledgerid,
    });

    for (var image in images!) {
      request.files.add(await http.MultipartFile.fromPath('uploaded_images', image.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = json.decode(responseBody); 
      var responses = data['responses'];  // This is a list of images' results
      if (responses.isNotEmpty) {
        var firstResponse = responses[0];  // Get the first image response
        var description = firstResponse['response_text']['description'] ?? 'not able to read';
        var quantity = firstResponse['response_text']['quantity'] ?? 0.0;
        var rate = firstResponse['response_text']['rate'] ?? 0.0;
        await _showSuccessAnimation();
        showSuccessFlushbar(context, 'Data autofilled successfully!');
        Future.delayed(Duration.zero, () {
          if(mounted){
            setState(() {
              descriptionController.text = description.toString();
              quantityController.text = quantity.toString();
              rateController.text = rate.toString();
              cloudinary_url = firstResponse['image_url'];
              calculateAmount();
              uploading = false;  // Set image URL
            });
          }
        });
      } else {
        _showErrorMessage("No responses found!, Please upload again");
        Future.delayed(Duration.zero, () {
          if(mounted){
            setState(() => uploading = false);
          }
        });
      }
    } else {
      _showErrorMessage("Upload failed!");
      Future.delayed(Duration.zero, () {
        if(mounted){
          setState(() => uploading = false);
        }
      });
    }
  }

  // Submit Final Data
  Future<void> submitFinalData() async {
    final bodyData = json.encode({
      'description': descriptionController.text,
      'quantity': double.tryParse(quantityController.text) ?? 0.0,
      'rate': double.tryParse(rateController.text) ?? 0.0,
      'amount': calculatedAmount,
      'tag':'C',
    });

    String apiUrl = 'https://credolabs.xyz/client/v1/supplier/invoice/add/';
    if (widget.type == "customer_credit" || widget.type == "customer_debit") {
      apiUrl = 'https://credolabs.xyz/client/v1/customer/invoice/add/';
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
        'Type':widget.type,
      },
      body: bodyData,
    );

    if (response.statusCode == 200) {
      await _showSuccessAnimation();
      if(mounted){
        Navigator.pop(context, true); 
      }
      // _sendPushNotification(phoneNumber.toString(), "New Invoice", "New Invoice", {"New Invoice":"New Invoice"});
      // _sendPushNotification(widget.phone_number, "🆕 New Invoice - ${widget.name}", "📝 Description - ${descriptionController.text} | 💰 Amount - ${calculatedAmount}", {"New Invoice By ${widget.name}":"New Invoice By ${widget.name}"});
    }
    else if(response.statusCode==400){
      _showErrorMessage("Please enter correct details!");
    } else {
      _showErrorMessage("Failed to submit receipt!");
    }
  }

  Future<void> uploadAudioAndFetchData() async {
    if (recordedAudio == null) {
      _showErrorMessage("No audio recorded!");
      return;
    }

    Future.delayed(Duration.zero, () {
      if(mounted){
        setState(() => uploading = true);
      }
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://credolabs.xyz/biz/v1/upload-audio/'), 
    );

    request.headers.addAll({
      'Client-ID': widget.clientid,
      'Customer-ID': widget.customerid,
      'Ledger-ID': widget.ledgerid,
    });

    request.files.add(await http.MultipartFile.fromPath('uploaded_audio', recordedAudio!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = json.decode(responseBody);
      var audioResponse = data['responses']; 
      if(audioResponse.isNotEmpty){
        var description = audioResponse[0]['response_text']['description'] ?? 'not able to read';
        var quantity = audioResponse[0]['response_text']['quantity'] ?? 0.0;
        var rate = audioResponse[0]['response_text']['rate'] ?? 0.0;
        
        await _showSuccessAnimation();
        showSuccessFlushbar(context, 'Data autofilled successfully!');

        Future.delayed(Duration.zero, () {
          if (mounted) {
            setState(() {
              descriptionController.text = description.toString();
              quantityController.text = quantity.toString();
              rateController.text = rate.toString();
              cloudinary_url = audioResponse[0]['audio_url'];
              calculateAmount();
              uploading = false;
            });
          }
        });

        await _showSuccessAnimation();
        showSuccessFlushbar(context, 'Audio and data autofilled successfully!');
      }
      else{
        _showErrorMessage("No responses found!, Please upload again");
        Future.delayed(Duration.zero, () {
          if(mounted){
            setState(() => uploading = false);
          }
        });
      }
      
    } else {
      _showErrorMessage("Audio upload failed!");
      setState(() {
        uploading = false;
      });
    }
    Future<http.StreamedResponse> sendRequest(http.MultipartRequest request) async {
      return await request.send();
    }
  }

  Future<void> recordAudio() async {
    // Logic to start and stop recording
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String filePath = p.join(appDocDir.path, "recording.wav");

    bool hasPermission = await _audioRecorder.hasPermission();
    if (hasPermission) {
      if (_isRecording) {
        String? filePath = await _audioRecorder.stop();
        if (filePath != null) {
          setState(() {
            recordedAudio = XFile(filePath);
            _recordedAudioPath = filePath;
            audioRecorded = true;
            _isRecording = false;
            images = [];
          });
        }
      } else {
        await _audioRecorder.start(const RecordConfig(), path: filePath.toString());
        setState(() {
          _isRecording = true;
          audioRecorded = false;
          images = [];
        });
      }
    } else {
      print("Permission not granted for recording!");
    }
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

  // Capture Image
  Future<void> captureImage() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            images = [...?images, photo]; 
            audioRecorded=false; // Append new image while keeping previous ones
          });
        }
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Top bar background
      statusBarIconBrightness: Brightness.dark, // Icon color (dark on white)
      systemNavigationBarColor: Colors.white, // Bottom nav bar
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            S.of(context).add_receipt,
            maxLines: 3,
            minFontSize: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: AutoSizeText(
                        S.of(context).upload_receipt_photos,
                        maxLines: 3,
                        minFontSize: 5,
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
                        maxLines: 2,
                        minFontSize: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: captureImage,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                      label: AutoSizeText(
                        _isRecording ? S.of(context).stopRecording : S.of(context).recordAudio,
                        maxLines: 2,
                        minFontSize: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: recordAudio,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              AutoSizeText(
                S.of(context).recordedAudioPreview,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                minFontSize: 5,
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _playAudio,
              ),
              SizedBox(height: 10),
              if(audioRecorded && !(images != null && images!.isNotEmpty))
                ElevatedButton(
                  onPressed: uploading ? null : uploadAudioAndFetchData,
                  child: uploading
                      ? Center(
                          child: Lottie.asset(
                            'assets/animation/Loading.json',
                            width: 50,
                            height: 50,
                            repeat: true,
                          ),
                        )
                      : AutoSizeText(
                          "${S.of(context).submit_and_autofill} ${S.of(context).audio}",
                          maxLines: 2,
                          minFontSize: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              if (images != null && images!.isNotEmpty && !(audioRecorded))

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
                        ).toList(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: uploading ? null : uploadImagesAndFetchData,
                      child: uploading
                          ? Center(
                              child: Lottie.asset(
                                'assets/animation/Loading.json',
                                width: 50,
                                height: 50,
                                repeat: true,
                              ),
                            )
                          : AutoSizeText(
                              "${S.of(context).submit_and_autofill} ${S.of(context).image}",
                              maxLines: 2,
                              minFontSize: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),
              Divider(height: 30),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: quantityController,
                      onChanged: (_) => calculateAmount(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Quantity'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: rateController,
                      onChanged: (_) => calculateAmount(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Rate'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  '${S.of(context).amount} : ₹$calculatedAmount',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  minFontSize: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: submitFinalData,
              //   child: AutoSizeText(
              //     S.of(context).submit_receipt,
              //     maxLines: 2,
              //     minFontSize: 5,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
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
                      S.of(context).submit_receipt,
                      maxLines: 2,
                      minFontSize: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            ],
          ),
        ),
      ),
    )
    );
  }

}
