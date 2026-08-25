import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/grade_model.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/models/subject_model.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';

/// Lets a teacher review every mark registered for a class over the term,
/// across all assessment types (quiz, test, exam, essay, lab report,
/// practical, assignment, project), and edit a mark if it was entered
/// wrong. Optionally filter down to a single term.
class ViewMarksScreen extends StatefulWidget {
  const ViewMarksScreen({super.key});

  @override
  State<ViewMarksScreen> createState() => _ViewMarksScreenState();
}

class _ViewMarksScreenState extends State<ViewMarksScreen> {
  String? _selectedClassId;
  int? _selectedTerm; // null = all terms
  bool _isLoading = false;
  List<GradeModel> _grades = [];

  Future<void> _onClassSelected(String classId) async {
    setState(() {
      _selectedClassId = classId;
      _isLoading = true;
      _grades = [];
    });

    final provider = context.read<TeacherProvider>();
    // loadClassDetails populates selectedClassStudents/selectedClassSubjects,
    // which this screen uses to resolve names for display.
    await provider.loadClassDetails(classId);
    final grades = await provider.getGradesForClass(classId);

    if (!mounted) return;
    setState(() {
      _grades = grades;
      _isLoading = false;
    });
  }

  Future<void> _refreshGrades() async {
    if (_selectedClassId == null) return;
    final provider = context.read<TeacherProvider>();
    final grades = await provider.getGradesForClass(_selectedClassId!);
    if (!mounted) return;
    setState(() => _grades = grades);
  }

  String _assessmentTypeLabel(AssessmentType type) {
    switch (type) {
      case AssessmentType.quiz:
        return 'Quiz';
      case AssessmentType.test:
        return 'Test';
      case AssessmentType.exam:
        return 'Exam';
      case AssessmentType.essay:
        return 'Essay';
      case AssessmentType.labReport:
        return 'Lab Report';
      case AssessmentType.practical:
        return 'Practical';
      case AssessmentType.assignment:
        return 'Assignment';
      case AssessmentType.project:
        return 'Project';
    }
  }

  Color _percentColor(double pct) {
    if (pct >= 70) return AppColors.secondaryGreen;
    if (pct >= 50) return AppColors.accentOrange;
    return AppColors.error;
  }

  Future<void> _showEditGradeDialog(
      GradeModel grade,
      StudentModel? student,
      SubjectModel? subject,
      ) async {
    final scoreController =
    TextEditingController(text: grade.score.toStringAsFixed(0));
    final maxScoreController =
    TextEditingController(text: grade.maxScore.toStringAsFixed(0));
    String? formError;
    bool isSaving = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text('Edit Mark',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              content: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student?.fullName ?? grade.studentId} · '
                          '${subject?.name ?? grade.subjectId}',
                      style: GoogleFonts.roboto(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      grade.title,
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Score',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: scoreController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: _dialogInputDecoration(),
                                style: GoogleFonts.roboto(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Max score',
                                  style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: maxScoreController,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                decoration: _dialogInputDecoration(),
                                style: GoogleFonts.roboto(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (formError != null) ...[
                      const SizedBox(height: 10),
                      Text(formError!,
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: AppColors.error)),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                  isSaving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                    final score =
                    double.tryParse(scoreController.text.trim());
                    final maxScore = double.tryParse(
                        maxScoreController.text.trim());

                    if (score == null || maxScore == null) {
                      setDialogState(
                              () => formError = 'Enter valid numbers.');
                      return;
                    }
                    if (maxScore <= 0) {
                      setDialogState(() =>
                      formError = 'Max score must be above 0.');
                      return;
                    }
                    if (score < 0 || score > maxScore) {
                      setDialogState(() => formError =
                      'Score must be between 0 and $maxScore.');
                      return;
                    }

                    setDialogState(() {
                      isSaving = true;
                      formError = null;
                    });

                    await context.read<TeacherProvider>().updateGrade(
                      gradeId: grade.id,
                      score: score,
                      maxScore: maxScore,
                    );

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: isSaving
                      ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    scoreController.dispose();
    maxScoreController.dispose();
    await _refreshGrades();
  }

  InputDecoration _dialogInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        final visibleGrades = _selectedTerm == null
            ? _grades
            : _grades.where((g) => g.term == _selectedTerm).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            title: Text(
              'View Marks',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilters(provider),
                  const SizedBox(height: 16),
                  _buildMarksList(provider, visibleGrades),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilters(TeacherProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Class',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedClassId,
                  decoration: _filterInputDecoration(hint: 'Select a class'),
                  items: provider.classes
                      .map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.name} · Term ${c.term}',
                        style: GoogleFonts.roboto(fontSize: 13)),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _onClassSelected(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Term',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<int?>(
                  value: _selectedTerm,
                  decoration: _filterInputDecoration(hint: 'All terms'),
                  items: [
                    DropdownMenuItem(
                        value: null,
                        child: Text('All terms',
                            style: GoogleFonts.roboto(fontSize: 13))),
                    ...[1, 2, 3].map((t) => DropdownMenuItem(
                      value: t,
                      child: Text('Term $t',
                          style: GoogleFonts.roboto(fontSize: 13)),
                    )),
                  ],
                  onChanged: (value) => setState(() => _selectedTerm = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksList(TeacherProvider provider, List<GradeModel> grades) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              Text('Registered Marks',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              if (_selectedClassId != null)
                Text('${grades.length} entries',
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 14),
          if (_selectedClassId == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text('Select a class above to view its marks.',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
            )
          else if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (grades.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    _selectedTerm == null
                        ? 'No marks registered for this class yet.'
                        : 'No marks registered for Term $_selectedTerm.',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...grades.map((g) => _gradeRow(g)),
        ],
      ),
    );
  }

  Widget _gradeRow(GradeModel grade) {
    final provider = context.read<TeacherProvider>();
    StudentModel? student;
    try {
      student = provider.selectedClassStudents
          .firstWhere((s) => s.id == grade.studentId);
    } catch (_) {
      student = null;
    }
    SubjectModel? subject;
    try {
      subject = provider.selectedClassSubjects
          .firstWhere((s) => s.id == grade.subjectId);
    } catch (_) {
      subject = null;
    }

    final color = _percentColor(grade.percentage);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Text(
              student?.initials ?? '?',
              style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student?.fullName ?? grade.studentId,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis),
                Text(
                  '${subject?.name ?? grade.subjectId} · ${grade.title}',
                  style: GoogleFonts.roboto(
                      fontSize: 11, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _assessmentTypeLabel(grade.assessmentType),
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              '${grade.score.toStringAsFixed(0)} / ${grade.maxScore.toInt()}',
              textAlign: TextAlign.right,
              style: GoogleFonts.roboto(
                  fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 56,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                grade.letterGrade,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showEditGradeDialog(grade, student, subject),
            icon: Icon(Icons.edit_outlined,
                size: 17, color: AppColors.textSecondary),
            tooltip: 'Edit mark',
          ),
        ],
      ),
    );
  }

  InputDecoration _filterInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(fontSize: 13, color: AppColors.textTertiary),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }
}
