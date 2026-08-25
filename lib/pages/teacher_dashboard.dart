import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/report_model.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/services/sis_service.dart';
import 'package:report_portal_boom/pages/students_marks_entry.dart';
import 'package:report_portal_boom/pages/report_generation_screen.dart';
import 'package:report_portal_boom/pages/report_detail_screen.dart';
import 'package:report_portal_boom/pages/view_marks_screen.dart';
import 'package:report_portal_boom/providers/teacher_provider.dart';
import '../Bloc/auth/auth_provider.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedNavIndex = 0;
  int _selectedClassIndex = 0;

  // Classes view: which class cards are expanded, and each one's cached
  // roster. Kept local to this widget (not on TeacherProvider) since
  // TeacherProvider.selectedClassStudents is a single shared field used by
  // the mark-entry/report-detail flows — reusing it here would let
  // expanding one class card clobber another's roster.
  final Set<String> _expandedClassIds = {};
  final Map<String, List<StudentModel>> _classRosterCache = {};
  final Set<String> _loadingRosterFor = {};

  Future<void> _toggleClassExpanded(String classId) async {
    if (_expandedClassIds.contains(classId)) {
      setState(() => _expandedClassIds.remove(classId));
      return;
    }
    setState(() => _expandedClassIds.add(classId));

    if (_classRosterCache.containsKey(classId)) return; // already fetched

    setState(() => _loadingRosterFor.add(classId));
    final students = await SisService.instance.getStudentsByClass(classId);
    if (!mounted) return;
    setState(() {
      _classRosterCache[classId] = students;
      _loadingRosterFor.remove(classId);
    });
  }

  @override
  void initState() {
    super.initState();
    // Defer until after the first frame so context.read is safe here
    // and this doesn't run mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = context.read<AuthProvider>();
      // TODO: remove this fallback once /login is wired into the app flow
      // and populates AuthProvider.userId. initialRoute currently skips
      // /login, so auth.userId is null in local/dev runs.
      final teacherId = auth.userId ?? 'TCH-001';
      context.read<TeacherProvider>().initialize(teacherId);
    });
  }

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    _NavItem(icon: Icons.groups_outlined, label: 'Classes'),
    _NavItem(icon: Icons.description_outlined, label: 'Reports'),
    _NavItem(icon: Icons.calendar_today_outlined, label: 'Schedule'),
    _NavItem(icon: Icons.notifications_outlined, label: 'Notifications'),
    _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  // Colors assigned per class index
  static const List<Color> _classColors = [
    AppColors.primaryBlue,
    AppColors.secondaryGreen,
    Color(0xFF7C3AED),
    AppColors.accentOrange,
  ];

  Color _colorForIndex(int i) => _classColors[i % _classColors.length];

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 14) return '1 week ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
            children: [
              _buildSidebar(provider),
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(provider),
                    Expanded(child: _buildMainContent(provider)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────── SIDEBAR ───────────────────────────

  Widget _buildSidebar(TeacherProvider provider) {
    final auth = context.read<AuthProvider>();
    final name = provider.teacher?.fullName ?? auth.displayName;
    final initials = provider.teacher?.initials ?? 'T';

    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          // Logo
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
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
                  child: const Icon(Icons.school, color: Colors.white, size: 16),
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

          // Nav
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _navSectionLabel('MAIN'),
                  _navTile(0),
                  _navTile(1),
                  _navTile(2),
                  _navTile(3),
                  const SizedBox(height: 8),
                  _navSectionLabel('OTHER'),
                  _navTile(4),
                  _navTile(5),
                ],
              ),
            ),
          ),

          // User footer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                _avatar(initials: initials, radius: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Teacher',
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await context.read<AuthProvider>().logout();
                  },
                  child: Icon(
                    Icons.logout_outlined,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _navTile(int index) {
    final item = _navItems[index];
    final isActive = _selectedNavIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryBlue.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 17,
              color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              item.label,
              style: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.primaryBlue : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── TOP BAR ───────────────────────────

  Widget _buildTopBar(TeacherProvider provider) {
    final name = provider.teacher?.fullName ??
        context.read<AuthProvider>().displayName;
    final initials = provider.teacher?.initials ?? 'T';

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Good morning,',
                style: GoogleFonts.roboto(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _iconButton(Icons.search_outlined, onTap: () {}),
              const SizedBox(width: 8),
              _notificationButton(),
              const SizedBox(width: 10),
              _avatar(initials: initials, radius: 17),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 17, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _notificationButton() {
    return Stack(
      children: [
        _iconButton(Icons.notifications_outlined, onTap: () {}),
        Positioned(
          top: 7,
          right: 7,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatar({required String initials, required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
      child: Text(
        initials,
        style: GoogleFonts.roboto(
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }

  // ─────────────────────────── MAIN CONTENT ───────────────────────────

  // Nav index 1 is "Classes", index 2 is "Reports" — both get dedicated
  // views. Everything else still shows the dashboard.
  Widget _buildMainContent(TeacherProvider provider) {
    return Stack(
      children: [
        _selectedNavIndex == 1
            ? _buildClassesView(provider)
            : _selectedNavIndex == 2
            ? _buildReportsView(provider)
            : _buildDashboardView(provider),
        Positioned(
          bottom: 24,
          right: 28,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportGenerationScreen()),
            ),
            icon: const Icon(Icons.upload_file_outlined, size: 16),
            label: Text(
              'New Report',
              style: GoogleFonts.roboto(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardView(TeacherProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(provider),
          const SizedBox(height: 16),
          _buildQuickActions(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentReports(provider)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _buildClassesCard(provider)),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── FULL REPORTS VIEW ───────────────────────────

  Widget _buildReportsView(TeacherProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reports',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${provider.reports.length} total',
                style: GoogleFonts.roboto(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: provider.reports.isEmpty
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.description_outlined,
                        size: 32, color: AppColors.textTertiary),
                    const SizedBox(height: 10),
                    Text('No reports generated yet',
                        style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
            )
                : Column(
              children: provider.reports
                  .map((r) => _reportRow(r, provider))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddStudentDialog(TeacherProvider provider) async {
    String? selectedClassId =
    provider.classes.isNotEmpty ? provider.classes.first.id : null;
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final studentNumberController = TextEditingController();
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
              title: Text('Add Student',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Class',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedClassId,
                      decoration: _dialogInputDecoration(hint: 'Select a class'),
                      items: provider.classes
                          .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.name} · Term ${c.term}',
                            style: GoogleFonts.roboto(fontSize: 13)),
                      ))
                          .toList(),
                      onChanged: (value) =>
                          setDialogState(() => selectedClassId = value),
                    ),
                    const SizedBox(height: 14),
                    Text('First name',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: firstNameController,
                      decoration: _dialogInputDecoration(hint: 'e.g. Amara'),
                      style: GoogleFonts.roboto(fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    Text('Last name',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: lastNameController,
                      decoration: _dialogInputDecoration(hint: 'e.g. Dlamini'),
                      style: GoogleFonts.roboto(fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    Text('Student number',
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: studentNumberController,
                      decoration: _dialogInputDecoration(hint: 'e.g. STU-2026-041'),
                      style: GoogleFonts.roboto(fontSize: 13),
                    ),
                    if (formError != null) ...[
                      const SizedBox(height: 12),
                      Text(formError!,
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: AppColors.error)),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'Other student details (DOB, guardian, address, etc.) '
                          'will be filled with placeholders you can edit later.',
                      style: GoogleFonts.roboto(
                          fontSize: 11, color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                    final firstName = firstNameController.text.trim();
                    final lastName = lastNameController.text.trim();
                    final studentNumber =
                    studentNumberController.text.trim();

                    if (selectedClassId == null) {
                      setDialogState(
                              () => formError = 'Please select a class.');
                      return;
                    }
                    if (firstName.isEmpty || lastName.isEmpty) {
                      setDialogState(() => formError =
                      'First and last name are required.');
                      return;
                    }
                    if (studentNumber.isEmpty) {
                      setDialogState(() =>
                      formError = 'Student number is required.');
                      return;
                    }

                    setDialogState(() {
                      isSaving = true;
                      formError = null;
                    });

                    final student = await provider.addStudentToClass(
                      classId: selectedClassId!,
                      firstName: firstName,
                      lastName: lastName,
                      studentNumber: studentNumber,
                    );

                    // Keep this widget's local roster cache in sync so
                    // the new student shows up immediately if that
                    // class card is already expanded.
                    if (mounted) {
                      setState(() {
                        _classRosterCache
                            .putIfAbsent(selectedClassId!, () => [])
                            .add(student);
                        _expandedClassIds.add(selectedClassId!);
                      });
                    }

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
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    studentNumberController.dispose();
  }

  InputDecoration _dialogInputDecoration({required String hint}) {
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

  // ─────────────────────────── CLASSES VIEW ───────────────────────────

  Widget _buildClassesView(TeacherProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Classes',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${provider.classes.length} total',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    onPressed: provider.classes.isEmpty
                        ? null
                        : () => _showAddStudentDialog(provider),
                    icon: const Icon(Icons.person_add_alt_outlined, size: 15),
                    label: Text('Add Student',
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Tap a class to view its student roster.',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (provider.classes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Center(
                child: Text('No classes assigned',
                    style: GoogleFonts.roboto(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
            )
          else
            ...List.generate(
              provider.classes.length,
                  (i) => _classCard(i, provider.classes[i]),
            ),
        ],
      ),
    );
  }

  Widget _classCard(int index, ClassModel cls) {
    final color = _colorForIndex(index);
    final isExpanded = _expandedClassIds.contains(cls.id);
    final isLoadingRoster = _loadingRosterFor.contains(cls.id);
    final roster = _classRosterCache[cls.id] ?? const <StudentModel>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _toggleClassExpanded(cls.id),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.groups_outlined, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cls.name,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${cls.displayName} · ${cls.studentCount} students · Term ${cls.term} · ${cls.academicYear}',
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(Icons.keyboard_arrow_down,
                        color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _classRoster(
              isLoadingRoster: isLoadingRoster,
              roster: roster,
              color: color,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 150),
          ),
        ],
      ),
    );
  }

  Widget _classRoster({
    required bool isLoadingRoster,
    required List<StudentModel> roster,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: isLoadingRoster
            ? const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )),
        )
            : roster.isEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('No students found for this class.',
              style: GoogleFonts.roboto(
                  fontSize: 13, color: AppColors.textSecondary)),
        )
            : Column(
          children: roster
              .map((s) => Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withOpacity(0.1),
                  child: Text(
                    s.initials,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(s.fullName,
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary)),
                      Text(
                        '${s.studentNumber} · ${s.gradeSection}',
                        style: GoogleFonts.roboto(
                            fontSize: 11,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (s.status != StudentStatus.active)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    child: Text(
                      s.status.name,
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ))
              .toList(),
        ),
      ),
    );
  }

  // ─────────────────────────── STAT CARDS ───────────────────────────

  Widget _buildStatsRow(TeacherProvider provider) {
    final stats = [
      _StatData(
        label: 'Total students',
        value: '${provider.studentCount}',
        sub: 'Across all classes',
        isPositive: null,
      ),
      _StatData(
        label: 'Classes',
        value: '${provider.classCount}',
        sub: 'Active this term',
        isPositive: null,
      ),
      _StatData(
        label: 'Reports generated',
        value: '${provider.reportCount}',
        sub: 'This academic year',
        isPositive: true,
      ),
      _StatData(
        label: 'Avg. class score',
        value: '74%',
        sub: 'No change',
        isPositive: null,
      ),
    ];

    return Row(
      children: List.generate(stats.length, (i) {
        final s = stats[i];
        final subColor = s.isPositive == null
            ? AppColors.textSecondary
            : s.isPositive!
            ? AppColors.secondaryGreen
            : AppColors.error;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < stats.length - 1 ? 14 : 0),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.label,
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text(
                  s.value,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(s.sub,
                    style: GoogleFonts.roboto(
                        fontSize: 11, color: subColor)),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────── QUICK ACTIONS ───────────────────────────

  Widget _buildQuickActions() {
    final actions = [
      _ActionData(
        icon: Icons.edit_note_outlined,
        label: 'Register Marks',
        bgColor: AppColors.primaryBlue.withOpacity(0.08),
        iconColor: AppColors.primaryBlue,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const StudentMarkEntry())),
      ),
      _ActionData(
        icon: Icons.folder_open_outlined,
        label: 'View Reports',
        bgColor: AppColors.secondaryGreen.withOpacity(0.1),
        iconColor: AppColors.secondaryGreenDark,
        onTap: () => setState(() => _selectedNavIndex = 2),
      ),
      _ActionData(
        icon: Icons.calendar_today_outlined,
        label: 'Schedule',
        bgColor: AppColors.accentOrange.withOpacity(0.1),
        iconColor: AppColors.accentOrangeDark,
        onTap: () {},
      ),
      _ActionData(
        icon: Icons.fact_check_outlined,
        label: 'View Marks',
        bgColor: Colors.grey.shade100,
        iconColor: Colors.grey.shade600,
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ViewMarksScreen())),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(actions.length, (i) {
              final a = actions[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: i < actions.length - 1 ? 10 : 0),
                  child: InkWell(
                    onTap: a.onTap,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: a.bgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(a.icon,
                                color: a.iconColor, size: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            a.label,
                            style: GoogleFonts.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── RECENT REPORTS ───────────────────────────

  Widget _buildRecentReports(TeacherProvider provider) {
    return Container(
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
              Text(
                'Recent Reports',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('View all',
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.primaryBlue)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (provider.reports.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No reports yet',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary)),
              ),
            )
          else
            ...provider.reports.take(5).map((r) => _reportRow(r, provider)),
        ],
      ),
    );
  }

  Widget _reportRow(ReportModel r, TeacherProvider provider) {
    // Resolve class name from provider classes
    String className = '';
    try {
      className = provider.classes
          .firstWhere((c) => c.id == r.classId)
          .name;
    } catch (_) {
      className = r.classId;
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReportDetailScreen(report: r)),
      ),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.description_outlined,
                  size: 15, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.title,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_timeAgo(r.generatedAt)} · $className',
                    style: GoogleFonts.roboto(
                        fontSize: 11,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: r.status == ReportStatus.published
                    ? AppColors.secondaryGreen.withOpacity(0.1)
                    : AppColors.accentOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                r.statusLabel,
                style: GoogleFonts.roboto(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: r.status == ReportStatus.published
                      ? AppColors.secondaryGreenDark
                      : AppColors.accentOrangeDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                size: 16, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────── CLASSES CARD ───────────────────────────

  Widget _buildClassesCard(TeacherProvider provider) {
    return Container(
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
              Text(
                'Your Classes',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('View all',
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.primaryBlue)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (provider.classes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No classes assigned',
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: AppColors.textSecondary)),
              ),
            )
          else
            ...List.generate(
              provider.classes.length,
                  (i) => _classRow(i, provider.classes[i]),
            ),
        ],
      ),
    );
  }

  Widget _classRow(int index, ClassModel cls) {
    final isSelected = _selectedClassIndex == index;
    final color = _colorForIndex(index);

    // Use a simple progress value based on student count relative to max
    final progress = (cls.studentCount / 30).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => setState(() => _selectedClassIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 6),
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.3)
                : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cls.name,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Term ${cls.term}',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15, top: 3, bottom: 7),
              child: Text(
                '${cls.studentCount} students',
                style: GoogleFonts.roboto(
                    fontSize: 11, color: AppColors.textSecondary),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── DATA MODELS ───────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _StatData {
  final String label;
  final String value;
  final String sub;
  final bool? isPositive;
  const _StatData({
    required this.label,
    required this.value,
    required this.sub,
    required this.isPositive,
  });
}

class _ActionData {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;
  const _ActionData({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}
