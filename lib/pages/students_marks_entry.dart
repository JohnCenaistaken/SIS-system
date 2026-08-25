import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/grade_model.dart';
import 'package:report_portal_boom/models/report_model.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/models/subject_model.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';
import '../Bloc/auth/auth_provider.dart';

class StudentMarkEntry extends StatefulWidget {
  const StudentMarkEntry({super.key});

  @override
  State<StudentMarkEntry> createState() => _StudentMarkEntryState();
}

class _StudentMarkEntryState extends State<StudentMarkEntry> {
  // Step tracking — 0: select class, 1: select subject, 2: enter marks
  int _currentStep = 0;

  ClassModel? _selectedClass;
  SubjectModel? _selectedSubject;
  AssessmentType _selectedAssessmentType = AssessmentType.test;
  String _assessmentTitle = '';
  double _maxScore = 100;
  int _selectedTerm = 2;

  // Map of studentId → score controller
  final Map<String, TextEditingController> _scoreControllers = {};
  bool _isSaving = false;

  final _titleController = TextEditingController();
  final _maxScoreController = TextEditingController(text: '100');

  @override
  void dispose() {
    _titleController.dispose();
    _maxScoreController.dispose();
    for (final c in _scoreControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── SIDEBAR ───────────────────────────

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  'School Portal',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _stepIndicator(0, 'Select class'),
                  _stepIndicator(1, 'Select subject & type'),
                  _stepIndicator(2, 'Enter marks'),
                ],
              ),
            ),
          ),
          // Back to dashboard
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border:
              Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Back to dashboard',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepIndicator(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.secondaryGreen
                  : isActive
                  ? AppColors.primaryBlue
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check,
                  size: 13, color: Colors.white)
                  : Text(
                '${step + 1}',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight:
              isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── TOP BAR ───────────────────────────

  Widget _buildTopBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
        Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Text(
            'Mark entry',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          if (_selectedClass != null)
            _breadcrumb(_selectedClass!.name),
          if (_selectedSubject != null) ...[
            Icon(Icons.chevron_right,
                size: 16, color: AppColors.textTertiary),
            _breadcrumb(_selectedSubject!.name),
          ],
        ],
      ),
    );
  }

  Widget _breadcrumb(String label) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ─────────────────────────── CONTENT ───────────────────────────

  Widget _buildContent() {
    switch (_currentStep) {
      case 0:
        return _buildSelectClassStep();
      case 1:
        return _buildSelectSubjectStep();
      case 2:
        return _buildEnterMarksStep();
      default:
        return _buildSelectClassStep();
    }
  }

  // ─────────────────────────── STEP 1: SELECT CLASS ───────────────────────────

  Widget _buildSelectClassStep() {
    final provider = context.watch<TeacherProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select a class',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose the class you want to enter marks for.',
            style: GoogleFonts.roboto(
                fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),
          if (provider.classes.isEmpty)
            Center(
              child: Text('No classes available',
                  style: GoogleFonts.roboto(
                      color: AppColors.textSecondary)),
            )
          else
            ...provider.classes.asMap().entries.map((e) {
              final cls = e.value;
              final color = _classColor(e.key);
              final isSelected = _selectedClass?.id == cls.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () async {
                    setState(() => _selectedClass = cls);
                    await provider.loadClassDetails(cls.id);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? color
                            : Colors.grey.shade100,
                        width: isSelected ? 1.5 : 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.groups_outlined,
                              color: color, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                cls.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${cls.studentCount} students · Term ${cls.term} · ${cls.academicYear}',
                                style: GoogleFonts.roboto(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle,
                              color: color, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _selectedClass == null
                    ? null
                    : () => setState(() => _currentStep = 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  AppColors.primaryBlue.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Continue',
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── STEP 2: SELECT SUBJECT & TYPE ───────────────────────────

  Widget _buildSelectSubjectStep() {
    final provider = context.watch<TeacherProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment details',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select the subject, assessment type and enter a title.',
            style: GoogleFonts.roboto(
                fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 28),

          // Subject selection
          Text(
            'Subject',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: provider.selectedClassSubjects.map((s) {
              final isSelected = _selectedSubject?.id == s.id;
              return InkWell(
                onTap: () =>
                    setState(() => _selectedSubject = s),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    s.name,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Assessment type
          Text(
            'Assessment type',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AssessmentType.values.map((type) {
              final isSelected =
                  _selectedAssessmentType == type;
              return InkWell(
                onTap: () => setState(
                        () => _selectedAssessmentType = type),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondaryGreen
                        .withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondaryGreen
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Text(
                    _assessmentTypeLabel(type),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.secondaryGreenDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Assessment title
          Text(
            'Assessment title',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _titleController,
            onChanged: (v) =>
                setState(() => _assessmentTitle = v),
            decoration: InputDecoration(
              hintText:
              'e.g. Quiz: Algebra Basics, Test: Chapter 5',
              hintStyle: GoogleFonts.roboto(
                  fontSize: 13, color: AppColors.textTertiary),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: AppColors.primaryBlue, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Max score and term row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Max score',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _maxScoreController,
                      keyboardType:
                      TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (v) => setState(() =>
                      _maxScore =
                          double.tryParse(v) ?? 100),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12),
                      ),
                      style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Term',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: _selectedTerm,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primaryBlue,
                              width: 1.5),
                        ),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12),
                      ),
                      items: [1, 2, 3].map((t) {
                        return DropdownMenuItem(
                          value: t,
                          child: Text('Term $t',
                              style: GoogleFonts.roboto(
                                  fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (v) => setState(
                              () => _selectedTerm = v ?? 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () =>
                    setState(() => _currentStep = 0),
                icon: const Icon(Icons.arrow_back,
                    size: 15),
                label: Text('Back',
                    style: GoogleFonts.roboto(
                        fontSize: 13)),
                style: TextButton.styleFrom(
                    foregroundColor:
                    AppColors.textSecondary),
              ),
              ElevatedButton(
                onPressed: (_selectedSubject == null ||
                    _assessmentTitle.trim().isEmpty)
                    ? null
                    : _proceedToMarkEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                  AppColors.primaryBlue.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Enter marks',
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward,
                        size: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _proceedToMarkEntry() {
    final provider = context.read<TeacherProvider>();
    // Initialise a controller for each student
    for (final student
    in provider.selectedClassStudents) {
      _scoreControllers[student.id] ??=
          TextEditingController();
    }
    setState(() => _currentStep = 2);
  }

  // ─────────────────────────── STEP 3: ENTER MARKS ───────────────────────────

  Widget _buildEnterMarksStep() {
    final provider = context.watch<TeacherProvider>();
    final students = provider.selectedClassStudents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter marks',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_selectedSubject!.name} · $_assessmentTitle · Max: ${_maxScore.toInt()}',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              // Quick fill all button
              OutlinedButton.icon(
                onPressed: () => _showQuickFillDialog(),
                icon: const Icon(Icons.auto_fix_high,
                    size: 15),
                label: Text('Quick fill',
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: BorderSide(
                      color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Header row
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const SizedBox(width: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Student',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ),
                SizedBox(
                  width: 120,
                  child: Text('Score / ${_maxScore.toInt()}',
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Student rows
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              separatorBuilder: (_, __) => Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey.shade100,
              ),
              itemBuilder: (_, i) =>
                  _studentMarkRow(students[i]),
            ),
          ),
          const SizedBox(height: 28),

          // Action buttons
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () =>
                    setState(() => _currentStep = 1),
                icon: const Icon(Icons.arrow_back,
                    size: 15),
                label: Text('Back',
                    style: GoogleFonts.roboto(
                        fontSize: 13)),
                style: TextButton.styleFrom(
                    foregroundColor:
                    AppColors.textSecondary),
              ),
              Row(
                children: [
                  // Save as draft — just saves grades
                  OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () => _saveMarks(
                        generateReport: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                      AppColors.textPrimary,
                      side: BorderSide(
                          color: Colors.grey.shade300),
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8)),
                    ),
                    child: Text('Save marks',
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500)),
                  ),
                  const SizedBox(width: 10),
                  // Save and generate report
                  ElevatedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _saveMarks(
                        generateReport: true),
                    icon: _isSaving
                        ? const SizedBox(
                      width: 14,
                      height: 14,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                        Icons.upload_file_outlined,
                        size: 15),
                    label: Text(
                        _isSaving
                            ? 'Saving...'
                            : 'Save & generate report',
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      AppColors.primaryBlue
                          .withOpacity(0.4),
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _studentMarkRow(StudentModel student) {
    final controller = _scoreControllers[student.id] ??
        TextEditingController();
    final scoreText = controller.text;
    final score = double.tryParse(scoreText);
    final pct = score != null ? (score / _maxScore * 100) : null;

    Color pctColor = AppColors.textTertiary;
    if (pct != null) {
      if (pct >= 70) pctColor = AppColors.secondaryGreen;
      else if (pct >= 50) pctColor = AppColors.accentOrange;
      else pctColor = AppColors.error;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 16,
            backgroundColor:
            AppColors.primaryBlue.withOpacity(0.1),
            child: Text(
              student.initials,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  student.studentNumber,
                  style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Score input
          SizedBox(
            width: 90,
            child: TextField(
              controller: controller,
              keyboardType:
              const TextInputType.numberWithOptions(
                  decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: GoogleFonts.roboto(
                    fontSize: 13,
                    color: AppColors.textTertiary),
                filled: true,
                fillColor: AppColors.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 1.5),
                ),
                contentPadding:
                const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 10),
              ),
              style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 12),
          // Percentage badge
          SizedBox(
            width: 52,
            child: pct != null
                ? Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: pctColor.withOpacity(0.1),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                '${pct.toStringAsFixed(0)}%',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: pctColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── QUICK FILL DIALOG ───────────────────────────

  void _showQuickFillDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        title: Text('Quick fill',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a score to apply to all students.',
              style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType:
              const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: InputDecoration(
                hintText: 'Score',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding:
                const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                setState(() {
                  for (final c
                  in _scoreControllers.values) {
                    c.text = val;
                  }
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── SAVE MARKS ───────────────────────────

  Future<void> _saveMarks(
      {required bool generateReport}) async {
    final provider = context.read<TeacherProvider>();
    final auth = context.read<AuthProvider>();

    // Validate at least one score is entered
    final hasAnyScore = _scoreControllers.values
        .any((c) => c.text.trim().isNotEmpty);
    if (!hasAnyScore) {
      _showSnackbar('Please enter at least one score.',
          isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final grades = <GradeModel>[];

      // Pre-generate the report id (if we're generating a report) so each
      // grade can reference it directly via GradeModel.reportId, instead of
      // relying on title/class/term convention-matching after the fact.
      final String? reportId =
      generateReport ? 'RPT-${now.millisecondsSinceEpoch}' : null;

      for (final entry in _scoreControllers.entries) {
        final scoreText = entry.value.text.trim();
        if (scoreText.isEmpty) continue;
        final score = double.tryParse(scoreText);
        if (score == null) continue;

        grades.add(GradeModel(
          id: 'GRD-${now.millisecondsSinceEpoch}-${entry.key}',
          studentId: entry.key,
          subjectId: _selectedSubject!.id,
          classId: _selectedClass!.id,
          assessmentType: _selectedAssessmentType,
          title: _assessmentTitle,
          score: score,
          maxScore: _maxScore,
          date: now,
          term: _selectedTerm,
          reportId: reportId,
        ));
      }

      final gradesSuccess =
      await provider.submitGrades(grades);

      if (!gradesSuccess) {
        _showSnackbar('Failed to save marks.',
            isError: true);
        return;
      }

      if (generateReport) {
        final report = ReportModel(
          id: reportId!,
          title:
          '$_assessmentTitle — ${_selectedClass!.name}',
          classId: _selectedClass!.id,
          teacherId: auth.userId ?? provider.teacher?.id ?? 'TCH-001',
          term: _selectedTerm,
          academicYear: _selectedClass!.academicYear,
          generatedAt: now,
          studentIds: grades.map((g) => g.studentId).toList(),
          status: ReportStatus.published,
          type: ReportType.assessmentReport,
        );

        final reportSuccess =
        await provider.submitReport(report);

        if (!reportSuccess) {
          _showSnackbar(
              'Marks saved but report generation failed.',
              isError: true);
          return;
        }

        _showSnackbar(
            'Marks saved and report generated successfully!');
      } else {
        _showSnackbar(
            '${grades.length} marks saved successfully!');
      }

      // Return to dashboard after short delay
      await Future.delayed(
          const Duration(milliseconds: 800));
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackbar(String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style:
            GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: isError
            ? AppColors.error
            : AppColors.secondaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Color _classColor(int index) {
    const colors = [
      AppColors.primaryBlue,
      AppColors.secondaryGreen,
      Color(0xFF7C3AED),
      AppColors.accentOrange,
    ];
    return colors[index % colors.length];
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
}
