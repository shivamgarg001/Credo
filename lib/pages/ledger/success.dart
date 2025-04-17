import 'package:auto_size_text/auto_size_text.dart';
import 'package:credo/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';  // Optional, for animation

// SuccessScreen widget
class SuccessScreen extends StatefulWidget {
  final VoidCallback onDismissed;

  const SuccessScreen({super.key, required this.onDismissed});

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playSuccessSound();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('assets.sounds/success.mp3'));  // Update the sound path as needed
    Future.delayed(Duration(seconds: 3), widget.onDismissed);  // Close after sound finishes
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: widget.onDismissed,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('animation/SuccessAnimation.json', width: 100, height: 100),  // Success animation
                AutoSizeText(
                                                overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

                  S.of(context).success,
                  style: TextStyle(color: Colors.white, fontFamily: 'SF-Pro', fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Function to show the success screen
void showSuccessScreen(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SuccessScreen(
          onDismissed: () {
            Navigator.pop(context);  // Dismiss the success screen
            // You can also navigate to another screen here, if needed
          },
        ),
      );
    },
  );
}
