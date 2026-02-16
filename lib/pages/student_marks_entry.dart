import 'package:flutter/material.dart';
import 'package:report_portal_boom/Components/premium_report_card.dart';
import '../Components/report_card.dart';
import '../models/report_model.dart';

class StudentMarkEntry extends StatefulWidget {
  const StudentMarkEntry({super.key});

  @override
  State<StudentMarkEntry> createState() => _StudentMarkEntryState();
}

class _StudentMarkEntryState extends State<StudentMarkEntry> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _subjects = ['Mathematics', 'Science', 'English', 'History'];
  final Map<String, String> _marks = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Student Marks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitForm,
            tooltip: 'Generate Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStudentInfoSection(),
              const SizedBox(height: 24),
              _buildMarksEntrySection(),
              const SizedBox(height: 24),
              _buildCommentsSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarksEntrySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subject Marks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._subjects.map((subject) => _buildMarkInputField(subject)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkInputField(String subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: subject,
          border: const OutlineInputBorder(),
          suffixText: '%',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required';
          final mark = double.tryParse(value);
          if (mark == null || mark < 0 || mark > 100) {
            return 'Enter valid mark (0-100)';
          }
          return null;
        },
        onSaved: (value) => _marks[subject] = value!,
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Teacher Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _commentsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Enter comments',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.picture_as_pdf),
      label: const Text('Generate Report'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      onPressed: _submitForm,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the report object
      final report = StudentReport(
        studentName: _nameController.text,
        studentId: _idController.text,
        gradeLevel: 'Grade 10', // You can make this dynamic
        schoolYear: '2023-2024',
        schoolName: 'Japan Advanced Nurturing School',
        reportDate: DateTime.now(),
        teacherComments: _commentsController.text,
        subjects: _marks.entries.map((entry) => SubjectGrade(
          subjectName: entry.key,
          gradeValue: double.parse(entry.value),
          letterGrade: _calculateGrade(double.parse(entry.value)),
        )).toList(),
      );

      // Navigate to report preview
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumReportCard(report: report),
        ),
      );
    }
  }

  String _calculateGrade(double mark) {
    if (mark >= 90) return 'A';
    if (mark >= 80) return 'B';
    if (mark >= 70) return 'C';
    if (mark >= 60) return 'D';
    return 'F';
  }
}