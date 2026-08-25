import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/models/announcement_model.dart';
import 'package:report_portal_boom/providers/landing_page_provider.dart';
import 'package:report_portal_boom/utils/responsive_layout.dart';

import 'login_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandingPageProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Consumer<LandingPageProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.announcements.isEmpty) {
            return _buildErrorState(provider);
          }
          return _buildPage(provider);
        },
      ),
    );
  }

  Widget _buildPage(LandingPageProvider provider) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(child: _buildNav()),
        SliverToBoxAdapter(child: _buildHero()),
        SliverToBoxAdapter(child: _buildFeatures()),
        SliverToBoxAdapter(child: _buildRoleCards()),
        SliverToBoxAdapter(child: _buildAnnouncements(provider)),
        SliverToBoxAdapter(child: _buildFooter()),
      ],
    );
  }

  // ─────────────────────────── NAV ───────────────────────────

  Widget _buildNav() {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 48,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (!isMobile) ...[
            _navLink('Home'),
            _navLink('Features'),
            _navLink('About'),
            _navLink('Contact'),
            const SizedBox(width: 12),
          ],
          OutlinedButton(
            onPressed: _showLoginDialog,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Student login'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _showLoginDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: GoogleFonts.roboto(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Teacher login'),
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        textStyle: GoogleFonts.roboto(fontSize: 13),
      ),
      child: Text(label),
    );
  }

  // ─────────────────────────── HERO ───────────────────────────

  Widget _buildHero() {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 56 : 80,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome,
                    size: 13, color: AppColors.primaryBlueDark),
                const SizedBox(width: 6),
                Text(
                  'Academic year 2025–2026',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlueDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your school, all in one place',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 30 : 44,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'Access grades, reports, schedules and announcements. '
                  'Built for students and teachers at Bright Future Academy.',
              style: GoogleFonts.roboto(
                fontSize: isMobile ? 14 : 16,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showLoginDialog,
                icon: const Icon(Icons.school_outlined, size: 16),
                label: const Text('Student login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _showLoginDialog,
                icon: const Icon(Icons.person_outline, size: 16),
                label: const Text('Teacher login'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: GoogleFonts.roboto(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 56),
          Wrap(
            spacing: 0,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _statItem('1,200+', 'Students enrolled'),
              _statDivider(),
              _statItem('80+', 'Teachers'),
              _statDivider(),
              _statItem('42', 'Classrooms'),
              _statDivider(),
              _statItem('Term 2', 'Currently active'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.roboto(
                fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 0.5, height: 32, color: Colors.grey.shade200);
  }

  // ─────────────────────────── FEATURES ───────────────────────────

  Widget _buildFeatures() {
    final isMobile = ResponsiveLayout.isMobile(context);

    final features = [
      _FeatureData(
        icon: Icons.bar_chart_outlined,
        label: 'Grades & reports',
        desc: 'View term results, progress reports and subject breakdowns at any time.',
        bgColor: AppColors.primaryBlue.withOpacity(0.08),
        iconColor: AppColors.primaryBlue,
      ),
      _FeatureData(
        icon: Icons.calendar_today_outlined,
        label: 'Class schedules',
        desc: 'Never miss a lesson. Access your full timetable and upcoming events.',
        bgColor: AppColors.secondaryGreen.withOpacity(0.1),
        iconColor: AppColors.secondaryGreenDark,
      ),
      _FeatureData(
        icon: Icons.notifications_outlined,
        label: 'Announcements',
        desc: 'Stay up to date with important school news and notices from administration.',
        bgColor: AppColors.accentOrange.withOpacity(0.1),
        iconColor: AppColors.accentOrangeDark,
      ),
      _FeatureData(
        icon: Icons.description_outlined,
        label: 'Report generation',
        desc: 'Teachers can generate and distribute student reports with one click.',
        bgColor: const Color(0xFF7C3AED).withOpacity(0.08),
        iconColor: const Color(0xFF7C3AED),
      ),
      _FeatureData(
        icon: Icons.groups_outlined,
        label: 'Class management',
        desc: 'Manage class rosters, mark attendance and track student performance.',
        bgColor: AppColors.secondaryGreen.withOpacity(0.08),
        iconColor: AppColors.secondaryGreenDark,
      ),
      _FeatureData(
        icon: Icons.lock_outline,
        label: 'Secure access',
        desc: 'Role-based logins ensure each user only sees what is relevant to them.',
        bgColor: AppColors.error.withOpacity(0.08),
        iconColor: AppColors.error,
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionEyebrow('Features'),
          const SizedBox(height: 10),
          Text(
            'Everything you need to stay on track',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Text(
              'From academic progress to daily schedules — the portal keeps '
                  'students, teachers, and parents aligned.',
              style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6),
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 3.5 : 1.6,
            ),
            itemCount: features.length,
            itemBuilder: (_, i) => _featureCard(features[i]),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(_FeatureData f) {
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: f.bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(f.icon, color: f.iconColor, size: 18),
          ),
          const SizedBox(height: 14),
          Text(
            f.label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            f.desc,
            style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── ROLE CARDS ───────────────────────────

  Widget _buildRoleCards() {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionEyebrow('Access'),
          const SizedBox(height: 10),
          Text(
            'Sign in as a student or teacher',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Text(
              'Each role has its own dedicated experience, tailored to what matters most to you.',
              style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6),
            ),
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(children: [
            _studentRoleCard(),
            const SizedBox(height: 16),
            _teacherRoleCard(),
          ])
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _studentRoleCard()),
              const SizedBox(width: 16),
              Expanded(child: _teacherRoleCard()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _studentRoleCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school_outlined,
                    size: 13, color: AppColors.primaryBlueDark),
                const SizedBox(width: 5),
                Text(
                  'Student',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBlueDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('For students',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Log in to check your grades, view your schedule and read the latest school announcements.',
            style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.6),
          ),
          const SizedBox(height: 20),
          ...[
            'View term grades and progress',
            'Access your class timetable',
            'Read school announcements',
            'Download your report cards',
          ].map((item) => _roleListItem(item, AppColors.primaryBlue)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showLoginDialog,
            icon: const Icon(Icons.arrow_forward, size: 15),
            label: const Text('Student login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.roboto(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teacherRoleCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_outline,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 5),
                Text(
                  'Teacher',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('For teachers',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(
            'Manage your classes, enter student marks, generate reports and keep track of your schedule.',
            style: GoogleFonts.roboto(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.6),
          ),
          const SizedBox(height: 20),
          ...[
            'Manage classes and rosters',
            'Enter and update student marks',
            'Generate and send reports',
            'View your full timetable',
          ].map((item) =>
              _roleListItem(item, AppColors.secondaryGreenDark)),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _showLoginDialog,
            icon: const Icon(Icons.arrow_forward, size: 15),
            label: const Text('Teacher login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.roboto(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleListItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check, size: 15, color: color),
          const SizedBox(width: 8),
          Text(text,
              style: GoogleFonts.roboto(
                  fontSize: 13, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // ─────────────────────────── ANNOUNCEMENTS ───────────────────────────

  Widget _buildAnnouncements(LandingPageProvider provider) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionEyebrow('Latest news'),
          const SizedBox(height: 10),
          Text(
            'School announcements',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 22 : 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Important updates from the school administration.',
            style: GoogleFonts.roboto(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.6),
          ),
          const SizedBox(height: 32),
          if (provider.isRefreshing)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: LinearProgressIndicator(),
            ),
          if (provider.announcements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'No announcements available',
                  style: GoogleFonts.roboto(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...provider.announcements.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _announcementItem(a),
            )),
        ],
      ),
    );
  }

  // Takes AnnouncementModel directly from SisService
  Widget _announcementItem(AnnouncementModel a) {
    final color = _categoryColor(a.category);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.title,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${a.categoryLabel} · ${_timeAgo(a.publishedAt)}',
                  style: GoogleFonts.roboto(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (a.isPinned)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.push_pin_outlined,
                  size: 14, color: AppColors.textTertiary),
            ),
        ],
      ),
    );
  }

  Color _categoryColor(AnnouncementCategory category) {
    switch (category) {
      case AnnouncementCategory.administration:
        return AppColors.primaryBlue;
      case AnnouncementCategory.academics:
        return AppColors.secondaryGreen;
      case AnnouncementCategory.events:
        return AppColors.accentOrange;
      case AnnouncementCategory.sports:
        return AppColors.error;
      case AnnouncementCategory.general:
        return const Color(0xFF7C3AED);
    }
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 14) return '1 week ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${(diff.inDays / 30).floor()} months ago';
  }

  // ─────────────────────────── FOOTER ───────────────────────────

  Widget _buildFooter() {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 32,
      ),
      color: Colors.white,
      child: isMobile
          ? Column(children: [
        _footerLogo(),
        const SizedBox(height: 16),
        _footerLinks(),
        const SizedBox(height: 16),
        _footerCopy(),
      ])
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _footerLogo(),
          _footerLinks(),
          _footerCopy(),
        ],
      ),
    );
  }

  Widget _footerLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.school, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 8),
        Text(
          'School Portal',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _footerLinks() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['Privacy', 'Terms', 'Contact'].map((label) {
        return TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: GoogleFonts.roboto(fontSize: 12),
          ),
          child: Text(label),
        );
      }).toList(),
    );
  }

  Widget _footerCopy() {
    return Text(
      '© ${DateTime.now().year} School Portal. All rights reserved.',
      style:
      GoogleFonts.roboto(fontSize: 12, color: AppColors.textSecondary),
    );
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Widget _sectionEyebrow(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
        letterSpacing: 0.6,
      ),
    );
  }

  Widget _buildErrorState(LandingPageProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Something went wrong',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(provider.error ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: provider.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── DATA MODELS ───────────────────────────

class _FeatureData {
  final IconData icon;
  final String label;
  final String desc;
  final Color bgColor;
  final Color iconColor;
  const _FeatureData({
    required this.icon,
    required this.label,
    required this.desc,
    required this.bgColor,
    required this.iconColor,
  });
}