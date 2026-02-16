import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import '../models/report_model.dart';
import 'dart:typed_data';

class PdfReportService {
  static const _defaultPadding = 20.0;
  static const _smallPadding = 10.0;
  static const _extraLargePadding = 30.0;
  static const _logoSize = 50.0;
  static const _signatureWidth = 100.0;

  static Future<Uint8List> generateReportCardPdf(StudentReport report) async {
    try {
      final pdf = pw.Document();
      final font = await _loadFont('assets/fonts/Roboto-Regular.ttf');

      pdf.addPage(
        pw.Page(
          margin: pw.EdgeInsets.all(_defaultPadding),
          theme: pw.ThemeData.withFont(base: font),
          pageFormat: PdfPageFormat.a4,
          build: (context) => _buildReportContent(report),
        ),
      );

      return await pdf.save();
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  static Future<pw.Font> _loadFont(String path) async {
    try {
      final fontData = await rootBundle.load(path);
      return pw.Font.ttf(fontData);
    } catch (e) {
      throw Exception('Failed to load font: $e');
    }
  }

  static pw.Widget _buildReportContent(StudentReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(report),
        pw.SizedBox(height: _defaultPadding),
        _buildStudentInfo(report),
        pw.SizedBox(height: _extraLargePadding),
        _buildGradesTable(report),
        pw.SizedBox(height: _defaultPadding),
        _buildCommentsSection(report),
        pw.SizedBox(height: _extraLargePadding),
        _buildFooter(report),
      ],
    );
  }

  static pw.Widget _buildHeader(StudentReport report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              report.schoolName,
              style:  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Official Report Card',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              'School Year: ${report.schoolYear}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        _buildSchoolLogo(),
      ],
    );
  }

  static pw.Widget _buildSchoolLogo() {
    return pw.Container(
      width: _logoSize,
      height: _logoSize,
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Center(
        child: pw.Text(
          'LOGO',
          style: const pw.TextStyle(fontSize: 8),
        ),
      ),
    );
  }

  static pw.Widget _buildStudentInfo(StudentReport report) {
    return pw.Container(
      padding: pw.EdgeInsets.all(_smallPadding),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(3),
        },
        children: [
          _buildTableRow('Student Name:', report.studentName, isBold: true),
          _buildTableRow('Student ID:', report.studentId),
          _buildTableRow('Grade Level:', report.gradeLevel),
          _buildTableRow(
              'Report Date:',
              '${report.reportDate.day}/${report.reportDate.month}/${report.reportDate.year}'
          ),
        ],
      ),
    );
  }

  static pw.TableRow _buildTableRow(String label, String value, {bool isBold = false}) {
    return pw.TableRow(
      children: [
        pw.Text(
          label,
          style: isBold
              ?  pw.TextStyle(fontWeight: pw.FontWeight.bold)
              : null,
        ),
        pw.Text(value),
      ],
    );
  }

  static pw.Widget _buildGradesTable(StudentReport report) {
    return pw.TableHelper.fromTextArray(
      border: pw.TableBorder.all(),
      headerStyle:  pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: const ['Subject', 'Grade', 'Percentage', 'Teacher', 'Comments'],
      data: report.subjects.map(_mapSubjectToRow).toList(),
    );
  }

  static List<String> _mapSubjectToRow(SubjectGrade subject) {
    return [
      subject.subjectName,
      subject.letterGrade,
      '${subject.gradeValue.toStringAsFixed(1)}%',
      subject.teacherName ?? '',
      subject.teacherComments ?? '',
    ];
  }

  static pw.Widget _buildCommentsSection(StudentReport report) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Overall Performance:'),
        pw.Text(
            '${report.overallLetterGrade} '
                '(${report.overallAverage.toStringAsFixed(1)}%) - '
                '${report.performanceComment}'
        ),
        pw.SizedBox(height: _smallPadding),
        _buildSectionTitle('Teacher Comments:'),
        pw.Text(report.teacherComments ?? 'No additional comments'),
      ],
    );
  }

  static pw.Widget _buildSectionTitle(String text) {
    return pw.Text(
      text,
      style:  pw.TextStyle(fontWeight: pw.FontWeight.bold),
    );
  }

  static pw.Widget _buildFooter(StudentReport report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _buildSignatureSection('Teacher Signature'),
        _buildSignatureSection('Principal Signature', isPrincipal: true),
      ],
    );
  }

  static pw.Widget _buildSignatureSection(String label, {bool isPrincipal = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
            'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
        pw.SizedBox(height: 40),
        pw.Text('___________________________'),
        pw.Text(label),
        if (isPrincipal) ...[
          pw.SizedBox(height: _smallPadding),
          pw.Container(
            width: _signatureWidth,
            height: 50,
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Center(child: pw.Text('Principal Sig')),
          ),
        ],
      ],
    );
  }
}