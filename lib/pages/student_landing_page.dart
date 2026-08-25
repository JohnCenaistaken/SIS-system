import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import '../Bloc/auth/auth_provider.dart';

class StudentLandingPage extends StatefulWidget {
  const StudentLandingPage({super.key});

  @override
  State<StudentLandingPage> createState() => _StudentLandingPageState();
}

class _StudentLandingPageState extends State<StudentLandingPage> {
  int _selectedNavIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    _NavItem(icon: Icons.grade_outlined, label: 'Grades'),
    _NavItem(icon: Icons.assignment_outlined, label: 'Assignments'),
    _NavItem(icon: Icons.calendar_today_outlined, label: 'Timetable'),
    _NavItem(icon: Icons.campaign_outlined, label: 'Announcements'),
    _NavItem(icon: Icons.person_outline, label: 'Profile'),
  ];

  Widget _currentPage() {
    switch (_selectedNavIndex) {
      case 0:
        return _StudentDashboard(onNavigate: (i) => setState(() => _selectedNavIndex = i));
      case 1:
        return const _StudentGradesPage();
      case 2:
        return const _StudentAssignmentsPage();
      case 3:
        return const _StudentTimetablePage();
      case 4:
        return const _StudentAnnouncementsPage();
      case 5:
        return const _StudentProfilePage();
      default:
        return _StudentDashboard(onNavigate: (i) => setState(() => _selectedNavIndex = i));
    }
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
                Expanded(child: _currentPage()),
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
                _avatar(radius: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alex Johnson',
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Grade 10 · Section A',
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

  Widget _buildTopBar() {
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
                'Alex Johnson',
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
              _avatar(radius: 17),
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

  Widget _avatar({required double radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
      child: Text(
        'AJ',
        style: GoogleFonts.roboto(
          fontSize: radius * 0.65,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}

// ─────────────────────────── DASHBOARD PAGE ───────────────────────────

class _StudentDashboard extends StatelessWidget {
  final void Function(int) onNavigate;
  const _StudentDashboard({required this.onNavigate});

  static const List<_GradeData> _recentGrades = [
    _GradeData(subject: 'Mathematics', assignment: 'Quiz: Algebra Basics', grade: 'A−', score: 90, color: AppColors.primaryBlue),
    _GradeData(subject: 'Physical Science', assignment: 'Lab: Photosynthesis', grade: 'B+', score: 87, color: AppColors.secondaryGreen),
    _GradeData(subject: 'English', assignment: 'Essay: Literary Analysis', grade: 'A', score: 95, color: AppColors.secondaryGreen),
    _GradeData(subject: 'History', assignment: 'Test: World War II', grade: 'B', score: 82, color: AppColors.accentOrange),
  ];

  static const List<_AssignmentData> _assignments = [
    _AssignmentData(subject: 'Mathematics', title: 'Chapter 5 Problem Set', due: 'Due tomorrow', priority: 'Urgent'),
    _AssignmentData(subject: 'English', title: 'Persuasive Essay Draft', due: 'Due Friday', priority: 'This Week'),
    _AssignmentData(subject: 'Physical Science', title: 'Lab Report: Titration', due: 'Due next Monday', priority: 'Normal'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsRow(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentGrades(context)),
              const SizedBox(width: 16),
              Expanded(flex: 1, child: _buildUpcomingAssignments(context)),
            ],
          ),
          const SizedBox(height: 16),
          _buildSubjectOverview(context),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      _StatData(label: 'Current GPA', value: '3.8', sub: '↑ from 3.6 last term', isPositive: true),
      _StatData(label: 'Attendance', value: '94%', sub: '2 absences this term', isPositive: null),
      _StatData(label: 'Assignments due', value: '3', sub: 'This week', isPositive: null),
      _StatData(label: 'Class rank', value: '12th', sub: 'Out of 58 students', isPositive: null),
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
                Text(
                  s.label,
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
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
                Text(
                  s.sub,
                  style: GoogleFonts.roboto(fontSize: 11, color: subColor),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRecentGrades(BuildContext context) {
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
                'Recent grades',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => onNavigate(1),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recentGrades.map((g) => _gradeRow(g)),
        ],
      ),
    );
  }

  Widget _gradeRow(_GradeData g) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: g.color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                g.grade,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: g.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  g.subject,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  g.assignment,
                  style: GoogleFonts.roboto(
                      fontSize: 11, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '${g.score}%',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: g.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAssignments(BuildContext context) {
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
                'Due soon',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () => onNavigate(2),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View all',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._assignments.map((a) => _assignmentRow(a)),
        ],
      ),
    );
  }

  Widget _assignmentRow(_AssignmentData a) {
    Color priorityColor;
    switch (a.priority) {
      case 'Urgent':
        priorityColor = AppColors.urgent;
        break;
      case 'This Week':
        priorityColor = AppColors.accentOrange;
        break;
      default:
        priorityColor = AppColors.primaryBlue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${a.subject} · ${a.due}',
                  style: GoogleFonts.roboto(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectOverview(BuildContext context) {
    final subjects = [
      _SubjectData(name: 'Mathematics', teacher: 'Mr. Light Yagami', average: 88, color: AppColors.primaryBlue),
      _SubjectData(name: 'Physical Science', teacher: 'Ms. Amara Dube', average: 82, color: AppColors.secondaryGreen),
      _SubjectData(name: 'English', teacher: 'Mrs. Sarah Nkosi', average: 91, color: const Color(0xFF7C3AED)),
      _SubjectData(name: 'History', teacher: 'Mr. James Moyo', average: 79, color: AppColors.accentOrange),
      _SubjectData(name: 'Life Sciences', teacher: 'Ms. Thandi Zulu', average: 85, color: AppColors.secondaryGreenDark),
      _SubjectData(name: 'Accounting', teacher: 'Mr. Sipho Dlamini', average: 74, color: AppColors.error),
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
            'Subject overview',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...subjects.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _subjectRow(s),
          )),
        ],
      ),
    );
  }

  Widget _subjectRow(_SubjectData s) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 160,
          child: Text(
            s.name,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(
            s.teacher,
            style: GoogleFonts.roboto(
                fontSize: 12, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: s.average / 100,
              minHeight: 4,
              backgroundColor: s.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(s.color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: s.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${s.average}%',
            style: GoogleFonts.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: s.color,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────── GRADES PAGE ───────────────────────────

class _StudentGradesPage extends StatelessWidget {
  const _StudentGradesPage();

  @override
  Widget build(BuildContext context) {
    final subjects = [
      _SubjectData(name: 'Mathematics', teacher: 'Mr. Light Yagami', average: 88, color: AppColors.primaryBlue),
      _SubjectData(name: 'Physical Science', teacher: 'Ms. Amara Dube', average: 82, color: AppColors.secondaryGreen),
      _SubjectData(name: 'English', teacher: 'Mrs. Sarah Nkosi', average: 91, color: const Color(0xFF7C3AED)),
      _SubjectData(name: 'History', teacher: 'Mr. James Moyo', average: 79, color: AppColors.accentOrange),
      _SubjectData(name: 'Life Sciences', teacher: 'Ms. Thandi Zulu', average: 85, color: AppColors.secondaryGreenDark),
      _SubjectData(name: 'Accounting', teacher: 'Mr. Sipho Dlamini', average: 74, color: AppColors.error),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grades',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Term 2 · Grade 10 Section A',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ...subjects.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _subjectGradeCard(s),
          )),
        ],
      ),
    );
  }

  Widget _subjectGradeCard(_SubjectData s) {
    final gradeLabel = s.average >= 90
        ? 'A'
        : s.average >= 80
        ? 'B'
        : s.average >= 70
        ? 'C'
        : 'D';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: s.color.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                gradeLabel,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: s.color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  s.teacher,
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: s.average / 100,
                minHeight: 4,
                backgroundColor: s.color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(s.color),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${s.average}%',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: s.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── ASSIGNMENTS PAGE ───────────────────────────

class _StudentAssignmentsPage extends StatelessWidget {
  const _StudentAssignmentsPage();

  static const List<_AssignmentData> _assignments = [
    _AssignmentData(subject: 'Mathematics', title: 'Chapter 5 Problem Set', due: 'Due tomorrow', priority: 'Urgent'),
    _AssignmentData(subject: 'English', title: 'Persuasive Essay Draft', due: 'Due Friday', priority: 'This Week'),
    _AssignmentData(subject: 'Physical Science', title: 'Lab Report: Titration', due: 'Due next Monday', priority: 'Normal'),
    _AssignmentData(subject: 'History', title: 'Research: Apartheid Era', due: 'Due next Wednesday', priority: 'Normal'),
    _AssignmentData(subject: 'Life Sciences', title: 'Diagram: Cell Division', due: 'Due in 2 weeks', priority: 'Normal'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assignments',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Term 2 · ${_assignments.length} pending',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _assignments.length,
              separatorBuilder: (_, __) => Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey.shade100,
              ),
              itemBuilder: (_, i) => _assignmentTile(_assignments[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _assignmentTile(_AssignmentData a) {
    Color priorityColor;
    switch (a.priority) {
      case 'Urgent':
        priorityColor = AppColors.urgent;
        break;
      case 'This Week':
        priorityColor = AppColors.accentOrange;
        break;
      default:
        priorityColor = AppColors.primaryBlue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${a.subject} · ${a.due}',
                  style: GoogleFonts.roboto(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              a.priority,
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: priorityColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── TIMETABLE PAGE ───────────────────────────

class _StudentTimetablePage extends StatelessWidget {
  const _StudentTimetablePage();

  @override
  Widget build(BuildContext context) {
    final periods = [
      _PeriodData(time: '07:30 – 08:15', subject: 'Mathematics', teacher: 'Mr. Light Yagami', room: 'Room 12', color: AppColors.primaryBlue),
      _PeriodData(time: '08:15 – 09:00', subject: 'Physical Science', teacher: 'Ms. Amara Dube', room: 'Lab 2', color: AppColors.secondaryGreen),
      _PeriodData(time: '09:00 – 09:15', subject: 'Break', teacher: '', room: '', color: AppColors.textTertiary),
      _PeriodData(time: '09:15 – 10:00', subject: 'English', teacher: 'Mrs. Sarah Nkosi', room: 'Room 7', color: const Color(0xFF7C3AED)),
      _PeriodData(time: '10:00 – 10:45', subject: 'History', teacher: 'Mr. James Moyo', room: 'Room 4', color: AppColors.accentOrange),
      _PeriodData(time: '10:45 – 11:30', subject: 'Life Sciences', teacher: 'Ms. Thandi Zulu', room: 'Lab 1', color: AppColors.secondaryGreenDark),
      _PeriodData(time: '11:30 – 12:15', subject: 'Lunch', teacher: '', room: '', color: AppColors.textTertiary),
      _PeriodData(time: '12:15 – 13:00', subject: 'Accounting', teacher: 'Mr. Sipho Dlamini', room: 'Room 9', color: AppColors.error),
      _PeriodData(time: '13:00 – 13:45', subject: 'Life Orientation', teacher: 'Ms. Lindiwe Khumalo', room: 'Room 3', color: AppColors.accentOrange),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timetable',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Term 2 · Monday to Friday',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: periods.length,
              separatorBuilder: (_, __) => Divider(
                height: 0,
                thickness: 0.5,
                color: Colors.grey.shade100,
              ),
              itemBuilder: (_, i) => _periodTile(periods[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodTile(_PeriodData p) {
    final isBreak = p.teacher.isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              p.time,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            width: 3,
            height: 36,
            decoration: BoxDecoration(
              color: p.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.subject,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isBreak
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                if (!isBreak)
                  Text(
                    '${p.teacher} · ${p.room}',
                    style: GoogleFonts.roboto(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── ANNOUNCEMENTS PAGE ───────────────────────────

class _StudentAnnouncementsPage extends StatelessWidget {
  const _StudentAnnouncementsPage();

  @override
  Widget build(BuildContext context) {
    final announcements = [
      _AnnouncementItem(title: 'Term 2 exams begin 20 May 2026', body: 'All students must bring their exam timetables. No electronic devices are allowed in the exam venues.', category: 'Administration', date: '2 days ago', color: AppColors.primaryBlue),
      _AnnouncementItem(title: 'Parent–teacher meetings scheduled for 15 May', body: 'Booking slots are available via the school office. Please ensure parents are notified in advance.', category: 'Academics', date: '4 days ago', color: AppColors.secondaryGreen),
      _AnnouncementItem(title: 'Sports day postponed to 28 May', body: 'Due to weather conditions, sports day has been moved. All participants should confirm availability.', category: 'Events', date: '1 week ago', color: AppColors.accentOrange),
      _AnnouncementItem(title: 'New library books available', body: 'The library has received new titles across Science, History and Fiction. Check the catalogue at reception.', category: 'Library', date: '2 weeks ago', color: const Color(0xFF7C3AED)),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Announcements',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${announcements.length} announcements',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ...announcements.map((a) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _announcementCard(a),
          )),
        ],
      ),
    );
  }

  Widget _announcementCard(_AnnouncementItem a) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: a.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        a.title,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      a.date,
                      style: GoogleFonts.roboto(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  a.body,
                  style: GoogleFonts.roboto(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: a.color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    a.category,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: a.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── PROFILE PAGE ───────────────────────────

class _StudentProfilePage extends StatelessWidget {
  const _StudentProfilePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1, child: _buildProfileCard(context)),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildDetailsCard(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Text(
              'AJ',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Alex Johnson',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Grade 10 · Section A',
            style: GoogleFonts.roboto(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            'Student No: 2024-10-042',
            style: GoogleFonts.roboto(
                fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Active',
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryGreenDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final details = [
      _DetailRow(label: 'Full name', value: 'Alexander James Johnson'),
      _DetailRow(label: 'Date of birth', value: '14 March 2010'),
      _DetailRow(label: 'Gender', value: 'Male'),
      _DetailRow(label: 'ID number', value: '1003145678901'),
      _DetailRow(label: 'Home address', value: '42 Mhlambanyatsi Rd, Manzini'),
      _DetailRow(label: 'Guardian name', value: 'Mrs. Susan Johnson'),
      _DetailRow(label: 'Guardian contact', value: '+268 7600 1234'),
      _DetailRow(label: 'Email', value: 'alex.johnson@student.school.sz'),
    ];

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
          Text(
            'Personal information',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...details.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    d.label,
                    style: GoogleFonts.roboto(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                Expanded(
                  child: Text(
                    d.value,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
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

class _GradeData {
  final String subject;
  final String assignment;
  final String grade;
  final int score;
  final Color color;
  const _GradeData({
    required this.subject,
    required this.assignment,
    required this.grade,
    required this.score,
    required this.color,
  });
}

class _AssignmentData {
  final String subject;
  final String title;
  final String due;
  final String priority;
  const _AssignmentData({
    required this.subject,
    required this.title,
    required this.due,
    required this.priority,
  });
}

class _SubjectData {
  final String name;
  final String teacher;
  final int average;
  final Color color;
  const _SubjectData({
    required this.name,
    required this.teacher,
    required this.average,
    required this.color,
  });
}

class _PeriodData {
  final String time;
  final String subject;
  final String teacher;
  final String room;
  final Color color;
  const _PeriodData({
    required this.time,
    required this.subject,
    required this.teacher,
    required this.room,
    required this.color,
  });
}

class _AnnouncementItem {
  final String title;
  final String body;
  final String category;
  final String date;
  final Color color;
  const _AnnouncementItem({
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    required this.color,
  });
}

class _DetailRow {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});
}