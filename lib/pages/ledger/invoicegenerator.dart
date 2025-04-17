import 'dart:convert';
import 'package:credo/pages/ledger/pdfscreen.dart';
import 'package:flutter/material.dart';
import 'invoice_service.dart';


class InvoiceGenerator extends StatefulWidget {
  final String jsonData;
  
  const InvoiceGenerator({super.key, required this.jsonData});

  @override
  State<InvoiceGenerator> createState() => _InvoiceGeneratorState();
}

class _InvoiceGeneratorState extends State<InvoiceGenerator> {
  bool _isGenerating = false;
  
  @override
  void initState() {
    super.initState();
    // Generate the invoice automatically when the widget is initialized
    _generateInvoice();
  }
  
  Future<void> _generateInvoice() async {
    setState(() {
      _isGenerating = true;
    });
    
    try {
      // Parse the JSON data
      final Map<String, dynamic> data = jsonDecode(widget.jsonData);
      
      // Generate the PDF
      final pdfBytes = await InvoiceService.generateInvoice(data);
      
      if (!mounted) return;
      
      // Navigate to the PDF view screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewScreen(pdfBytes: pdfBytes),
        ),
      );
    } catch (e) {
      // Show error if PDF generation fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate invoice: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generating Invoice'),
      ),
      body: Center(
        child: _isGenerating
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating Invoice in 3.. 2.. 1..'),
                ],
              )
            : const Text('Generating Invoice in 3.. 2.. 1..'),
      ),
    );
  }
}

