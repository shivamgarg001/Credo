import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:credo/generated/l10n.dart';
import 'package:credo/state/global_variables.dart';

class SelectImageBottomSheet extends StatelessWidget {
  const SelectImageBottomSheet({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    // Pick image from gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save image path to AppState and SharedPreferences
      String imagePath = pickedFile.path;
      Provider.of<AppState>(context, listen: false).setProfileImagePath(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            S.of(context).profile_photo,
            style: TextStyle(
              fontFamily: 'SF-Pro',
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage(context);  // Call image picker
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 30.0),
              // Camera button can be implemented similarly if needed
            ],
          ),
        ],
      ),
    );
  }
}
