import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/models/habit_model.dart';

class PdfService {
  static Future<Uint8List> generateHabitReport({
    required List<Habit> habits,
    DateTime? from,
    DateTime? to,
  }) async {
    final doc = pw.Document();
    final df = DateFormat('yMMMd');
    final rangeText = '${from != null ? df.format(from) : 'Start'} - ${to != null ? df.format(to) : 'Today'}';

    doc.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(24),
          textDirection: pw.TextDirection.ltr,
        ),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('StreakAura Habit Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Paragraph(text: 'Range: $rangeText'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Emoji', 'Habit', 'Created', 'Current Streak', 'Longest Streak', 'Check-ins'],
            data: habits.map((h) {
              final checks = h.checkIns.length;
              return [
                h.emoji,
                h.name,
                df.format(h.createdAt),
                h.currentStreak.toString(),
                h.longestStreak.toString(),
                checks.toString(),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey400),
          ),
        ],
      ),
    );

    return doc.save();
  }

  static Future<void> sharePdf(
    BuildContext context,
    Uint8List pdfBytes,
    String fileName,
  ) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }
}

