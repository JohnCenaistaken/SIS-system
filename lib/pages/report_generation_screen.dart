import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/subject_model.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';

/// Screen for generating a single student's report card locally.
/// Flow: pick a class -> pick a student -> enter marks per subject -> generate.
/// No backend call is made — everything is computed in-memory on this screen.
class ReportGenerationScreen extends StatefulWidget {
  const ReportGenerationScreen({super.key});

  @override
  State<ReportGenerationScreen> createState() =>
      _ReportGenerationScreenState();
}

/// One row of subject + marks input. Subject is picked from a dropdown
/// (populated from the selected class's subjects) rather than typed, and
/// each subject can only be used in one row at a time — enforced in
/// _buildMarksCard by excluding already-picked subjects from other rows'
/// dropdown options.
class _SubjectMarkRow {
  SubjectModel? subject;
  final TextEditingController marksController;
  _SubjectMarkRow({this.subject, String marks = ''})
      : marksController = TextEditingController(text: marks);

  void dispose() {
    marksController.dispose();
  }
}

/// Result of computing a report from the entered rows.
class _ReportResult {
  final List<MapEntry<String, double>> subjectMarks;
  final double total;
  final double average;
  final String grade;
  final Color gradeColor;

  _ReportResult({
    required this.subjectMarks,
    required this.total,
    required this.average,
    required this.grade,
    required this.gradeColor,
  });
}

class _ReportGenerationScreenState extends State<ReportGenerationScreen> {
  // Assumed max marks per subject. Adjust here if your app uses a different scale,
  // or make this a per-subject field if that's modeled elsewhere.
  static const double _maxMarksPerSubject = 100;

  String? _selectedClassId;
  String? _selectedStudentId;

  final List<_SubjectMarkRow> _rows = [
    _SubjectMarkRow(),
    _SubjectMarkRow(),
    _SubjectMarkRow(),
  ];

  _ReportResult? _result;
  String? _formError;

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  ClassModel? _classById(TeacherProvider provider, String? id) {
    if (id == null) return null;
    try {
      return provider.classes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  void _addRow() {
    setState(() => _rows.add(_SubjectMarkRow()));
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  void _resetRows() {
    for (final r in _rows) {
      r.dispose();
    }
    _rows
      ..clear()
      ..addAll([
        _SubjectMarkRow(),
        _SubjectMarkRow(),
        _SubjectMarkRow(),
      ]);
  }

  String _gradeFor(double averagePercent) {
    if (averagePercent >= 90) return 'A';
    if (averagePercent >= 75) return 'B';
    if (averagePercent >= 60) return 'C';
    if (averagePercent >= 40) return 'D';
    return 'F';
  }

  Color _gradeColorFor(String grade) {
    switch (grade) {
      case 'A':
        return AppColors.secondaryGreenDark;
      case 'B':
        return AppColors.primaryBlue;
      case 'C':
        return AppColors.accentOrangeDark;
      default:
        return AppColors.error;
    }
  }

  void _generateReport() {
    setState(() => _formError = null);

    if (_selectedClassId == null) {
      setState(() => _formError = 'Please select a class.');
      return;
    }
    if (_selectedStudentId == null) {
      setState(() => _formError = 'Please select a student.');
      return;
    }

    final entries = <MapEntry<String, double>>[];
    for (final row in _rows) {
      final subject = row.subject;
      final marksText = row.marksController.text.trim();
      if (subject == null && marksText.isEmpty) continue; // skip blank rows

      if (subject == null) {
        setState(() => _formError = 'Every row needs a subject selected.');
        return;
      }
      final marks = double.tryParse(marksText);
      if (marks == null) {
        setState(() =>
        _formError = 'Marks for "${subject.name}" must be a number.');
        return;
      }
      if (marks < 0 || marks > _maxMarksPerSubject) {
        setState(() => _formError =
        'Marks for "${subject.name}" must be between 0 and ${_maxMarksPerSubject.toInt()}.');
        return;
      }
      entries.add(MapEntry(subject.name, marks));
    }

    if (entries.isEmpty) {
      setState(() => _formError = 'Add at least one subject with marks.');
      return;
    }

    final total = entries.fold<double>(0, (sum, e) => sum + e.value);
    final average = total / (entries.length * _maxMarksPerSubject) * 100;
    final grade = _gradeFor(average);

    setState(() {
      _result = _ReportResult(
        subjectMarks: entries,
        total: total,
        average: average,
        grade: grade,
        gradeColor: _gradeColorFor(grade),
      );
    });
  }

  void _resetForm() {
    setState(() {
      _resetRows();
      _result = null;
      _formError = null;
      _selectedStudentId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        final selectedClass = _classById(provider, _selectedClassId);

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            title: Text(
              'Generate Report',
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
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSelectionCard(provider, selectedClass),
                  const SizedBox(height: 16),
                  _buildMarksCard(provider),
                  if (_formError != null) ...[
                    const SizedBox(height: 10),
                    _buildErrorBanner(_formError!),
                  ],
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  if (_result != null) ...[
                    const SizedBox(height: 20),
                    _buildReportCard(
                      selectedClass: selectedClass,
                      result: _result!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────── CLASS + STUDENT PICKER ───────────────────────

  Widget _buildSelectionCard(TeacherProvider provider, ClassModel? selectedClass) {
    return _card(
      title: 'Student & Class',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Class'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedClassId,
            decoration: _inputDecoration(hint: 'Select a class'),
            items: provider.classes
                .map((c) => DropdownMenuItem(
              value: c.id,
              child: Text(
                '${c.name} · Term ${c.term}',
                style: GoogleFonts.roboto(fontSize: 13),
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedClassId = value;
                _selectedStudentId = null; // reset student when class changes
                _resetRows(); // previous class's subjects no longer apply
              });
              if (value != null) {
                context.read<TeacherProvider>().loadClassDetails(value);
              }
            },
          ),
          const SizedBox(height: 16),
          _fieldLabel('Student'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedStudentId,
            decoration: _inputDecoration(
              hint: selectedClass == null
                  ? 'Select a class first'
                  : 'Select a student',
            ),
            // NOTE: ClassModel currently only exposes `studentIds` (no names) in
            // the code I've seen. If you have a Student model with real names,
            // swap the `.map` below to build items from that instead of raw IDs.
            items: (selectedClass?.studentIds ?? [])
                .map((id) => DropdownMenuItem(
              value: id,
              child: Text(
                'Student $id',
                style: GoogleFonts.roboto(fontSize: 13),
              ),
            ))
                .toList(),
            onChanged: selectedClass == null
                ? null
                : (value) => setState(() => _selectedStudentId = value),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── MARKS INPUT ───────────────────────────

  Widget _buildMarksCard(TeacherProvider provider) {
    final allSubjects = provider.selectedClassSubjects;
    final noSubjectsForClass = _selectedClassId != null && allSubjects.isEmpty;
    // Once every available subject is used across rows, stop allowing more
    // rows to be added — there'd be nothing left to pick for a new one.
    final atSubjectCapacity =
        allSubjects.isNotEmpty && _rows.length >= allSubjects.length;

    return _card(
      title: 'Subject Marks',
      trailing: TextButton.icon(
        onPressed: (_selectedClassId == null || atSubjectCapacity)
            ? null
            : _addRow,
        icon: const Icon(Icons.add, size: 16),
        label: Text('Add subject',
            style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w600)),
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedClassId == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('Select a class above to choose subjects.',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary)),
            )
          else if (noSubjectsForClass)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('No subjects found for this class.',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary)),
            ),
          ...List.generate(_rows.length, (i) {
            final row = _rows[i];

            // A subject already picked by another row shouldn't show up as
            // an option here — except the one this row itself has picked,
            // so its own dropdown still displays it as selected.
            final pickedElsewhere = _rows
                .where((r) => r != row)
                .map((r) => r.subject?.id)
                .whereType<String>()
                .toSet();
            final availableSubjects = allSubjects
                .where((s) => !pickedElsewhere.contains(s.id))
                .toList();

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<SubjectModel>(
                      value: row.subject,
                      decoration: _inputDecoration(
                        hint: _selectedClassId == null
                            ? 'Select a class first'
                            : 'Select subject',
                      ),
                      items: availableSubjects
                          .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.name,
                            style: GoogleFonts.roboto(fontSize: 13)),
                      ))
                          .toList(),
                      onChanged: (_selectedClassId == null ||
                          availableSubjects.isEmpty)
                          ? null
                          : (value) => setState(() => row.subject = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: row.marksController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                          hint: '/ ${_maxMarksPerSubject.toInt()}'),
                      style: GoogleFonts.roboto(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: _rows.length > 1 ? () => _removeRow(i) : null,
                    icon: Icon(Icons.close,
                        size: 16,
                        color: _rows.length > 1
                            ? AppColors.textTertiary
                            : Colors.grey.shade300),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────────────────────── ACTIONS ───────────────────────────

  Widget _buildActionButtons() {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _generateReport,
          icon: const Icon(Icons.description_outlined, size: 16),
          label: Text('Generate Report',
              style:
              GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(width: 10),
        TextButton(
          onPressed: _resetForm,
          child: Text('Reset',
              style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: GoogleFonts.roboto(fontSize: 12, color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── REPORT CARD ───────────────────────────

  Widget _buildReportCard({
    required ClassModel? selectedClass,
    required _ReportResult result,
  }) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Report Card',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    'Student $_selectedStudentId · ${selectedClass?.name ?? ''} '
                        '· Term ${selectedClass?.term ?? '-'}',
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: result.gradeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  result.grade,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: result.gradeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100)),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Subject',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text('Marks',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ),
                ],
              ),
              ...result.subjectMarks.map(
                    (e) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(e.key,
                          style: GoogleFonts.roboto(
                              fontSize: 13, color: AppColors.textPrimary)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${e.value.toStringAsFixed(0)} / ${_maxMarksPerSubject.toInt()}',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.roboto(
                            fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryStat('Total', result.total.toStringAsFixed(0)),
              _summaryStat(
                  'Average', '${result.average.toStringAsFixed(1)}%'),
              _summaryStat('Grade', result.grade, color: result.gradeColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryStat(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            GoogleFonts.roboto(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────── SHARED UI HELPERS ───────────────────────────

  Widget _card({required String title, required Widget child, Widget? trailing}) {
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
              Text(title,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(label,
        style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary));
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.roboto(fontSize: 13, color: AppColors.textTertiary),
      isDense: true,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        borderSide: BorderSide(color: AppColors.primaryBlue),
      ),
    );
  }
}
