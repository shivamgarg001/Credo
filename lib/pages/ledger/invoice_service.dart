import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class InvoiceService {
  /// Generates a PDF invoice from the provided data
  static Future<Uint8List> generateInvoice(Map<String, dynamic> data) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();
    final fontMedium = await PdfGoogleFonts.interMedium();

    // Extract data
    final items = data['items'] as List;
    final customer = data['customer'] as Map<String, dynamic>;
    
    // Calculate total
    double total = 0;
    for (var item in items) {
      total += (item['amount'] as num).toDouble();
    }

    // Generate invoice number and dates
    final invoiceNumber = 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}';
    final issueDate = DateTime.now();
    final dueDate = issueDate.add(const Duration(days: 30));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (pw.Context context) {
          // Show header only on the first page
          if (context.pageNumber == 1) {
            return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 32,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      invoiceNumber,
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 16,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Made By Credo',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 20,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'contact@example.com',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return pw.Container();
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
            ),
          );
        },
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 40),
            // Bill To & Invoice Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BILL TO',
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      customer['name'],
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 16,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      customer['phone'],
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 14,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                          'Issue Date: ',
                          style: pw.TextStyle(
                            font: fontMedium,
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '${issueDate.day}/${issueDate.month}/${issueDate.year}',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 40),
            // Table Header
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(
                    color: PdfColors.grey300,
                    width: 1,
                  ),
                ),
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                      'Description',
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Qty',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Rate',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Amount',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        font: fontMedium,
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table Items
            ...items.map((item) {
              // Parse the date string
              DateTime itemDate;
              try {
                itemDate = DateTime.parse(item['date']);
              } catch (e) {
                itemDate = DateTime.now(); // Fallback to current date if parsing fails
              }
              
              // Format the date
              String formattedDate = DateFormat('MMM d, yyyy').format(itemDate);
              String rawdesc = item['description'];
              String cleaneddesc = rawdesc.replaceAll('[', '').replaceAll(']', '');

              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 16),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.grey200,
                      width: 1,
                    ),
                  ),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            cleaneddesc ?? item['name'],
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 14,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Date: $formattedDate',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        (item['quantity'] as num).toString(),
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '₹${(item['rate'] as num).toStringAsFixed(2)}',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '₹${(item['amount'] as num).toStringAsFixed(2)}',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 14,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            pw.SizedBox(height: 20),
            // Total
            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          'Subtotal',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          '₹${total.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          'Tax (0%)',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          '₹0.00',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(color: PdfColors.grey300),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 16,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                      pw.Container(
                        width: 120,
                        child: pw.Text(
                          '₹${total.toStringAsFixed(2)}',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 16,
                            color: PdfColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Spacer(),
            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.only(top: 20),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  top: pw.BorderSide(
                    color: PdfColors.grey300,
                    width: 1,
                  ),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Payment Terms',
                        style: pw.TextStyle(
                          font: fontMedium,
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Due within 30 days',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Thank you for your business',
                        style: pw.TextStyle(
                          font: fontMedium,
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
