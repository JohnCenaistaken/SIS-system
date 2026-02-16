import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/report_model.dart';

class PremiumReportCard extends StatelessWidget {
  final StudentReport report;

  const PremiumReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Academic Report'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // School Header
            _buildSchoolHeader(),
            const SizedBox(height: 30),

            // Student Profile
            _buildStudentProfile(),
            const SizedBox(height: 30),

            // Academic Performance
            _buildAcademicPerformance(),
            const SizedBox(height: 30),

            // Teacher Comments
            _buildCommentsSection(),
            const SizedBox(height: 30),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSchoolHeader() {
    return Column(
      children: [
        Image.asset('assets/images/logo.jpg', height: 80), // Add your logo
        const SizedBox(height: 10),
        const Text('Japan Advanced Nurturing School',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            )),
        Text('OFFICIAL REPORT CARD',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 3,
              color: Color(0xFF7F8C8D),
            )),
        const Divider(height: 30, thickness: 2),
      ],
    );
  }

  Widget _buildStudentProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle,
                  size: 60, color: Color(0xFF3498DB)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.studentName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        _buildInfoChip('ID: ${report.studentId}'),
                        const SizedBox(width: 10),
                        _buildInfoChip(report.gradeLevel),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Term', 'Winter 2025'),
              _buildInfoItem('Issued',
                  DateFormat('MMM dd, yyyy').format(report.reportDate)),
              _buildInfoItem('Class', '1-D'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFECF0F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7F8C8D),
            )),
        SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildAcademicPerformance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ACADEMIC PERFORMANCE',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 20),
          ...report.subjects
              .map((subject) => _buildSubjectRow(subject))
              .toList(),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OVERALL PERFORMANCE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getGradeColor(report.overallLetterGrade),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${report.overallLetterGrade} (${report.overallAverage.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow(SubjectGrade subject) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              subject.subjectName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getGradeColor(subject.letterGrade).withOpacity(0.2),
                  border: Border.all(
                    color: _getGradeColor(subject.letterGrade),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    subject.letterGrade,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getGradeColor(subject.letterGrade),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              subject.teacherName ?? '',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TEACHER COMMENTS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              )),
          const SizedBox(height: 15),
          Text(
            report.teacherComments ?? 'No comments provided',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Text('RECOMMENDATIONS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              )),
          const SizedBox(height: 15),
          const Text(
            '• Continue excellent work in Mathematics\n'
            '• Focus on improving writing skills in English\n'
            '• Participate more in class discussions',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const Divider(height: 30, thickness: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSignature('Homeroom Teacher'),
            _buildSignature('Principal'),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          'Japan Advanced Nurturing School\n'
          '123 Academic Way, Tokyo, Japan\n'
          'www.jans.ed.jp',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
        ),
      ],
    );
  }

  Widget _buildSignature(String role) {
    return Column(
      children: [
        Container(
          height: 2,
          width: 100,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text(
          role,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return const Color(0xFF2ECC71);
      case 'B':
        return const Color(0xFF3498DB);
      case 'C':
        return const Color(0xFFF39C12);
      case 'D':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF7F8C8D);
    }
  }
}
