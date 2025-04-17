import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:credo/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;

class AudioRecorderManager extends StatefulWidget {
  const AudioRecorderManager({super.key});

  @override
  _AudioRecorderManagerState createState() => _AudioRecorderManagerState();
}

class _AudioRecorderManagerState extends State<AudioRecorderManager> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _recordedAudioPath;
  bool _isRecording = false;
  bool _isAudioRecorded = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final microphonePermission = await Permission.microphone.request();
    if (microphonePermission.isDenied) {
      print("Microphone permission denied!");
    }
  }

  Future<void> _recordAudio() async {
    if (_isRecording) {
      // Stop recording
      String? filePath = await _audioRecorder.stop();
      if (filePath != null) {
        setState(() {
          _isRecording = false;
          _recordedAudioPath = filePath;
          _isAudioRecorded = true;
        });
      }
    } else {
      // Start recording
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String filePath = p.join(appDocDir.path, "recording.wav");
      bool hasPermission = await _audioRecorder.hasPermission();
      if (hasPermission) {
        await _audioRecorder.start(const RecordConfig(),path: filePath.toString());
        setState(() {
          _isRecording = true;
          _isAudioRecorded = false;
          _recordedAudioPath = null;
        });
      } else {
        print("Permission not granted for recording!");
      }
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
      print("Error: No recorded audio available.");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          label: AutoSizeText(_isRecording ? S.of(context).stopRecording : S.of(context).recordAudio,                               
          overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
          onPressed: _recordAudio,
        ),
        if (_isAudioRecorded) ...[
          SizedBox(height: 10),
          AutoSizeText(
            S.of(context).recordedAudioPreview,
            style: TextStyle(fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size

          ),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _playAudio,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              print("Submitting Audio...");
            },
            child: AutoSizeText(S.of(context).submit_and_autofill,                               
            overflow: TextOverflow.clip,
                              maxLines: 2, // Allow wrapping
                              minFontSize: 5, // Minimum font size
),
          ),
        ],
      ],
    );
  }
}
