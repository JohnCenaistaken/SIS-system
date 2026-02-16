import 'package:flutter/material.dart';
import 'package:report_portal_boom/services/pdf_report_service.dart';
import '../models/report_model.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class ReportCardPage extends StatelessWidget {
  final StudentReport report;
  static const double _defaultPadding = 20.0;
  static const double _sectionSpacing = 30.0;

  const ReportCardPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(_defaultPadding),
        child: Column(
          children: [
            _buildReportPreview(),
            const SizedBox(height: _sectionSpacing),
            _buildGeneratePdfButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('${report.studentName}\'s Report Card'),
      actions: [
        IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () => _generatePdf(context),
          tooltip: 'Generate PDF',
        ),
      ],
    );
  }

  Widget _buildReportPreview() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(_defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const Divider(height: _sectionSpacing),
            _buildStudentInfoSection(),
            const SizedBox(height: _sectionSpacing),
            _buildGradesSection(),
            const SizedBox(height: _sectionSpacing),
            _buildCommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.schoolName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('Official Report Card'),
            Text('School Year: ${report.schoolYear}'),
          ],
        ),
        _buildSchoolLogo(),
      ],
    );
  }

  Widget _buildSchoolLogo() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(border: Border.all()),
      child: const Center(child: Text('LOGO')),
    );
  }

  Widget _buildStudentInfoSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(3),
        },
        children: [
          _buildInfoRow('Student:', report.studentName, isBold: true),
          _buildInfoRow('Grade:', report.gradeLevel),
          _buildInfoRow(
              'Date:',
              '${report.reportDate.day}/${report.reportDate.month}/${report.reportDate.year}'
          ),
        ],
      ),
    );
  }

  TableRow _buildInfoRow(String label, String value, {bool isBold = false}) {
    return TableRow(
      children: [
        Text(label, style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        Text(value),
      ],
    );
  }

  Widget _buildGradesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Performance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DataTable(
          columns: const [
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('G'), numeric: true),
            DataColumn(label: Text('Teacher')),
          ],
          rows: report.subjects.map(_buildGradeRow).toList(),
        ),
      ],
    );
  }

  DataRow _buildGradeRow(SubjectGrade subject) {
    return DataRow(
      cells: [
        DataCell(Text(subject.subjectName)),
        DataCell(Text(subject.letterGrade)),
        DataCell(Text(subject.teacherName ?? '')),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Performance Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Overall Performance: ${report.overallLetterGrade}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(report.performanceComment),
        const SizedBox(height: 10),
        const Text(
          'Teacher Comments:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(report.teacherComments ?? 'No additional comments'),
      ],
    );
  }

  Widget _buildGeneratePdfButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Generate PDF Report'),
      onPressed: () => _generatePdf(context),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Generating PDF...')),
      );

      final pdfBytes = await PdfReportService.generateReportCardPdf(report);
      await _savePdf(pdfBytes, '${report.studentName}_Report.pdf');

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('PDF generated successfully!')),
      );
    } catch (e) {
      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
    }
  }

  Future<void> _savePdf(Uint8List bytes, String fileName) async {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..style.display = 'none'
      ..download = fileName;

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}