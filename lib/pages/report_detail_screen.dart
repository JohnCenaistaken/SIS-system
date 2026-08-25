import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/grade_model.dart';
import 'package:report_portal_boom/models/report_model.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/models/subject_model.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';

/// Detail / preview screen for a single generated report.
/// Shows report metadata plus either:
///  - the marks table for the report's assessment (when matching GradeModel
///    entries can be found via TeacherProvider.getGradesForReport), or
///  - a plain student roster (fallback, e.g. for non-assessment report types
///    where no matching grades exist).
class ReportDetailScreen extends StatefulWidget {
  final ReportModel report;
  const ReportDetailScreen({super.key, required this.report});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  bool _loadingStudents = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<TeacherProvider>().loadClassDetails(widget.report.classId);
      if (mounted) setState(() => _loadingStudents = false);
    });
  }

  String _humanizeEnum(Object value) {
    final raw = value.toString().split('.').last;
    final spaced = raw.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
          (m) => '${m.group(1)} ${m.group(2)}',
    );
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final period = d.hour >= 12 ? 'PM' : 'AM';
    final minute = d.minute.toString().padLeft(2, '0');
    return '${months[d.month - 1]} ${d.day}, ${d.year} · $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        ClassModel? cls;
        try {
          cls = provider.classes.firstWhere((c) => c.id == report.classId);
        } catch (_) {
          cls = null;
        }

        final students = provider.selectedClassStudents
            .where((s) => report.studentIds.contains(s.id))
            .toList();

        final grades = provider.getGradesForReport(report);

        SubjectModel? subject;
        if (grades.isNotEmpty) {
          try {
            subject = provider.selectedClassSubjects
                .firstWhere((s) => s.id == grades.first.subjectId);
          } catch (_) {
            subject = null;
          }
        }

        final isPublished = report.status == ReportStatus.published;
        final statusColor = isPublished
            ? AppColors.secondaryGreenDark
            : AppColors.accentOrangeDark;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            title: Text(
              'Report Preview',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(report, cls, statusColor),
                  const SizedBox(height: 16),
                  _buildInfoCard(report, cls),
                  const SizedBox(height: 16),
                  if (grades.isNotEmpty)
                    _buildMarksCard(students, grades, subject)
                  else
                    _buildStudentsCard(students),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────── HEADER ───────────────────────────

  Widget _buildHeaderCard(ReportModel report, ClassModel? cls, Color statusColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.description_outlined,
                color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${cls?.name ?? report.classId} · Generated ${_formatDate(report.generatedAt)}',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              report.statusLabel,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── INFO GRID ───────────────────────────

  Widget _buildInfoCard(ReportModel report, ClassModel? cls) {
    final items = <MapEntry<String, String>>[
      MapEntry('Report ID', report.id),
      MapEntry('Class', cls?.name ?? report.classId),
      MapEntry('Term', 'Term ${report.term}'),
      MapEntry('Academic Year', report.academicYear),
      MapEntry('Type', _humanizeEnum(report.type)),
      MapEntry('Students Covered', '${report.studentIds.length}'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Report Details',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Wrap(
            runSpacing: 14,
            children: items.map((item) {
              return SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.key,
                        style: GoogleFonts.roboto(
                            fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(height: 3),
                    Text(item.value,
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── MARKS TABLE ───────────────────────────

  Color _percentColor(double pct) {
    if (pct >= 70) return AppColors.secondaryGreen;
    if (pct >= 50) return AppColors.accentOrange;
    return AppColors.error;
  }

  Widget _buildMarksCard(
      List<StudentModel> students,
      List<GradeModel> grades,
      SubjectModel? subject,
      ) {
    // Map studentId -> grade for quick lookup while iterating students
    final gradeByStudent = {for (final g in grades) g.studentId: g};
    final maxScore = grades.first.maxScore;
    final classAverage = grades.isEmpty
        ? 0.0
        : grades.map((g) => g.percentage).reduce((a, b) => a + b) /
        grades.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subject != null ? '${subject.name} Marks' : 'Marks',
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              Text(
                'Class avg: ${classAverage.toStringAsFixed(1)}%',
                style: GoogleFonts.roboto(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Student',
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary))),
                Expanded(
                    flex: 2,
                    child: Text('Score',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary))),
                Expanded(
                    flex: 2,
                    child: Text('Grade',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary))),
              ],
            ),
          ),
          Divider(color: Colors.grey.shade100, height: 1),
          if (students.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('No matching students found for this class.',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
            )
          else
            ...students.map((s) {
              final grade = gradeByStudent[s.id];
              final pct = grade?.percentage;
              final color = pct != null
                  ? _percentColor(pct)
                  : AppColors.textTertiary;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor:
                            AppColors.primaryBlue.withOpacity(0.1),
                            child: Text(s.initials,
                                style: GoogleFonts.roboto(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(s.fullName,
                                style: GoogleFonts.roboto(
                                    fontSize: 13,
                                    color: AppColors.textPrimary),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        grade != null
                            ? '${grade.score.toStringAsFixed(0)} / ${maxScore.toInt()}'
                            : '—',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            grade?.letterGrade ?? '—',
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  // ─────────────────────────── STUDENTS LIST (fallback) ───────────────────────────

  Widget _buildStudentsCard(List<StudentModel> students) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Students Included',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          if (_loadingStudents)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (students.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No matching students found for this class.',
                  style: GoogleFonts.roboto(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...students.map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor:
                    AppColors.primaryBlue.withOpacity(0.1),
                    child: Text(
                      s.initials,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.fullName,
                            style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary)),
                        Text(s.studentNumber,
                            style: GoogleFonts.roboto(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
