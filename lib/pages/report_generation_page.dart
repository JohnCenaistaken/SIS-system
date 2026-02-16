
import 'package:flutter/material.dart';

import '../models/report_model.dart';

class ReportGenerationScreen extends StatefulWidget {
  final String className;

  const ReportGenerationScreen({super.key, required this.className});

  @override
  State<ReportGenerationScreen> createState() => _ReportGenerationScreenState();
}

class _ReportGenerationScreenState extends State<ReportGenerationScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> students = [];
  List<String> subjects = ['Math', 'Science', 'English', 'History'];
  String reportType = 'Progress Report';
  String term = 'First Term';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Report - ${widget.className}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDraft,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Configuration
              _buildReportConfigSection(),
              const SizedBox(height: 24),

              // Student Marks Input
              _buildStudentInputSection(),
              const SizedBox(height: 24),

              // Generate Button
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Generate Report Cards'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  onPressed: _generateReports,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportConfigSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Report Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: reportType,
              decoration: const InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Progress Report', child: Text('Progress Report')),
                DropdownMenuItem(value: 'Terminal Report', child: Text('Terminal Report')),
                DropdownMenuItem(value: 'Special Report', child: Text('Special Report')),
              ],
              onChanged: (value) => setState(() => reportType = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: term,
              decoration: const InputDecoration(
                labelText: 'Term',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'First Term', child: Text('First Term')),
                DropdownMenuItem(value: 'Second Term', child: Text('Second Term')),
                DropdownMenuItem(value: 'Third Term', child: Text('Third Term')),
              ],
              onChanged: (value) => setState(() => term = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Additional Comments',
                border: OutlineInputBorder(),
                hintText: 'General class comments...',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInputSection() {
    // Initialize empty list if empty
    if (students.isEmpty) {
      students = List.generate(5, (index) => {
        'name': '',
        'id': 'STU${1000 + index}',
        ...{for (var subject in subjects) subject: ''},
        'comments': ''
      });
    }

    return Card(
        elevation: 2,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student Marks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _addStudent,
                  tooltip: 'Add Student',
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columnSpacing: 16,
                    columns: [
                const DataColumn(label: Text('Student')),
                const DataColumn(label: Text('ID')),
                      const DataColumn(label: Text('Comments')),
                      const DataColumn(label: Text('Actions')),
                ...subjects.map((subject) => DataColumn(
        label: SizedBox(width: 80, child: Text(subject)),
    ),
            )],
    rows: List<DataRow>.generate(
    students.length,
    (index) => DataRow(
    cells: [
    DataCell(
    SizedBox(
    width: 120,
    child: TextFormField(
    initialValue: students[index]['name'],
    decoration: const InputDecoration(
    hintText: 'Name',
    isDense: true,
    ),
    onChanged: (value) => students[index]['name'] = value,
    ),
    ),
    ),
    DataCell(Text(students[index]['id'])),
    ...subjects.map((subject) => DataCell(
    SizedBox(
    width: 80,
    child: TextFormField(
    keyboardType: TextInputType.number,
    initialValue: students[index][subject],
    decoration: const InputDecoration(
    hintText: 'Grade',
    isDense: true,
    ),
    onChanged: (value) => students[index][subject] = value,
    ),
    ),
    )),
    DataCell(
    SizedBox(
    width: 120,
    child: TextFormField(
    initialValue: students[index]['comments'],
    decoration: const InputDecoration(
    hintText: 'Comments',
    isDense: true,
    ),
    onChanged: (value) => students[index]['comments'] = value,
    ),
    ),
    ),
    DataCell(
    IconButton(
    icon: const Icon(Icons.delete, color: Colors.red),
    onPressed: () => _removeStudent(index),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }

  void _addStudent() {
    setState(() {
      students.add({
        'name': '',
        'id': 'STU${1000 + students.length}',
        ...{for (var subject in subjects) subject: ''},
        'comments': ''
      });
    });
  }

  void _removeStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  void _saveDraft() {
    // Implement draft saving logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft saved successfully')),
    );
  }

  void _generateReports() {
    if (_formKey.currentState!.validate()) {
      // Convert input data to StudentReport objects
      final reports = students.map((studentData) {
        final subjectGrades = subjects.map((subject) => SubjectGrade(
          subjectName: subject,
          gradeValue: double.tryParse(studentData[subject] ?? '0') ?? 0,
          teacherComments: studentData['comments'], letterGrade: '',
        )).toList();

        return StudentReport(
          studentName: studentData['name'],
          studentId: studentData['id'],
          gradeLevel: widget.className,
          schoolYear: '2023-2024',
          schoolName: 'Your School Name',
          reportDate: DateTime.now(),
          teacherComments: studentData['comments'],
          subjects: subjectGrades,
        );
      }).toList();

      // Navigate to preview or generate PDFs
      _showGenerationDialog(reports);
    }
  }

  void _showGenerationDialog(List<StudentReport> reports) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Reports'),
        content: Text('Generate ${reports.length} report cards?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processReports(reports);
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _processReports(List<StudentReport> reports) {
    // Implement your PDF generation and saving logic here
    // This would use your existing PdfReportService
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${reports.length} reports generated successfully'),
        duration: const Duration(seconds: 2),
      ),
    );

    // After generation, you might want to:
    // 1. Save to database
    // 2. Navigate to preview
    // 3. Share/save files
  }
}