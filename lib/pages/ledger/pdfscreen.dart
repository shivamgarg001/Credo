import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// Import XFile

class PdfViewScreen extends StatefulWidget {
  final List<int> pdfBytes;

  const PdfViewScreen({super.key, required this.pdfBytes});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  String pdfFilePath = "";

  @override
  void initState() {
    super.initState();
    _writePdfToFile();
  }

  // Function to write PDF bytes to a temporary file
  Future<void> _writePdfToFile() async {
    // Get the temporary directory asynchronously
    final directory = await getTemporaryDirectory();
    final pdfFile = File('${directory.path}/MadeByCredo.pdf');

    // Write the bytes to the file asynchronously
    await pdfFile.writeAsBytes(widget.pdfBytes);

    setState(() {
      pdfFilePath = pdfFile.path; // Save the file path to use in the PDF viewer
    });
  }

  // Share function to send the PDF to WhatsApp or other apps using XFile
  void _sharePdf() async {
    if (pdfFilePath.isNotEmpty) {
      // Convert the file path to an XFile
      XFile pdfXFile = XFile(pdfFilePath);

      // Share the PDF file using shareXFiles
      await Share.shareXFiles([pdfXFile], text: 'Check out my invoice!');
    } else {
      // In case the PDF is not available yet
      print('PDF is not ready for sharing.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Wait until the PDF file path is available before displaying the PDF
    if (pdfFilePath.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Invoice PDF"),
        ),
        body: Center(child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice PDF"),
      ),
      body: PDFView(
        filePath: pdfFilePath, // Path to the PDF file
      ),
      floatingActionButton: FloatingActionButton(onPressed: _sharePdf, child: Icon(Icons.share)),
    );
  }
}
