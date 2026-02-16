import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:report_portal_boom/Components/announcement_tile.dart';
import 'package:report_portal_boom/Components/quick_stats.dart';
import 'package:report_portal_boom/constants/app_colors.dart';
import 'package:report_portal_boom/pages/login_page.dart';
import 'package:report_portal_boom/providers/landing_page_provider.dart';
import 'package:report_portal_boom/utilities/responsive_layout.dart';

/// Website-style landing page for School SIS (Medium.com inspired)
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LandingPageProvider>().initialize();
      _heroController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showStudentLogin() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const LoginPage(),
    );
  }

  void _showParentLogin() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopNavigationBar(context),
      body: Consumer<LandingPageProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingState();
          }

          if (provider.error != null && provider.features.isEmpty) {
            return _buildErrorState(provider);
          }

          return _buildContent(context, provider);
        },
      ),
    );
  }

  /// Website-style top navigation bar (Medium.com inspired)
  PreferredSizeWidget _buildTopNavigationBar(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: _buildMaxWidthContainer(
        child: Row(
          children: [
            // Logo
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: AppColors.primaryBlue,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'School Portal',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Navigation Links (desktop only)
            if (!isMobile)
              Row(
                children: [
                  _NavLink(label: 'Home', onTap: () {}),
                  _NavLink(label: 'About', onTap: () {}),
                  _NavLink(label: 'Features', onTap: () {}),
                  _NavLink(label: 'Contact', onTap: () {}),
                  const SizedBox(width: AppColors.spacingM),
                  // Login Buttons
                  TextButton(
                    onPressed: _showStudentLogin,
                    child: Text(
                      'Student Login',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _showParentLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Parent Login',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            else
              // Mobile menu button
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Handle mobile menu
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(LandingPageProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: AppColors.spacingM),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppColors.spacingS),
          Text(
            provider.error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppColors.spacingL),
          ElevatedButton.icon(
            onPressed: provider.retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, LandingPageProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshAnnouncements,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Section
          _buildHeroSection(context),
          
          // Quick Stats Section
          _buildQuickStatsSection(context, provider),
          
          // Features/Quick Access Section
          _buildFeaturesSection(context, provider),
          
          // Announcements Section
          _buildAnnouncementsSection(context, provider),
          
          // Footer
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Max-width container for website-style layout (Medium.com style)
  Widget _buildMaxWidthContainer({required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveLayout.isMobile(context)
                ? AppColors.spacingM
                : AppColors.spacingXL,
          ),
          child: child,
        ),
      ),
    );
  }

  /// Hero Section - Clean, editorial style
  Widget _buildHeroSection(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? AppColors.spacingXXL : 120,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue,
              AppColors.primaryBlueLight,
            ],
          ),
        ),
        child: _buildMaxWidthContainer(
          child: FadeTransition(
            opacity: _heroController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // School Icon
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: Curves.easeOut,
                  )),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school,
                      size: isMobile ? 56 : 72,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? AppColors.spacingL : AppColors.spacingXL),

                // Main Title
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: Curves.easeOut,
                  )),
                  child: Text(
                    'Student & Parent Portal',
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 32 : 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isMobile ? AppColors.spacingM : AppColors.spacingL),

                // Subtitle
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: Curves.easeOut,
                  )),
                  child: Text(
                    'Your gateway to academic success. Access grades, schedules, assignments, and more.',
                    style: GoogleFonts.roboto(
                      fontSize: isMobile ? 16 : 20,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isMobile ? AppColors.spacingXL : 60),

                // Action Buttons
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _heroController,
                    curve: Curves.easeOut,
                  )),
                  child: Wrap(
                    spacing: AppColors.spacingM,
                    runSpacing: AppColors.spacingM,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _showStudentLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 32 : 40,
                            vertical: isMobile ? 16 : 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Student Login',
                          style: GoogleFonts.roboto(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: _showParentLogin,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 32 : 40,
                            vertical: isMobile ? 16 : 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Parent Login',
                          style: GoogleFonts.roboto(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Quick Stats Section
  Widget _buildQuickStatsSection(
      BuildContext context, LandingPageProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveLayout.isMobile(context)
              ? AppColors.spacingXXL
              : 80,
        ),
        color: AppColors.backgroundLight,
        child: _buildMaxWidthContainer(
          child: QuickStatsWidget(stats: provider.quickStats),
        ),
      ),
    );
  }

  /// Features/Quick Access Section
  Widget _buildFeaturesSection(
      BuildContext context, LandingPageProvider provider) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final quickActions = [
      _QuickAction(
        icon: Icons.assessment,
        label: 'Grades',
        color: AppColors.primaryBlue,
        description: 'Track your academic performance',
      ),
      _QuickAction(
        icon: Icons.calendar_today,
        label: 'Schedule',
        color: AppColors.secondaryGreen,
        description: 'View your class timetable',
      ),
      _QuickAction(
        icon: Icons.assignment,
        label: 'Assignments',
        color: AppColors.accentOrange,
        description: 'Manage your tasks',
      ),
      _QuickAction(
        icon: Icons.event_note,
        label: 'Events',
        color: AppColors.primaryBlue,
        description: 'School activities & dates',
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveLayout.isMobile(context)
              ? AppColors.spacingXXL
              : 80,
        ),
        child: _buildMaxWidthContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'Quick Access',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppColors.spacingS),
              Text(
                'Everything you need to manage your academic journey',
                style: GoogleFonts.roboto(
                  fontSize: isMobile ? 16 : 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: isMobile ? AppColors.spacingXL : AppColors.spacingXXL),

              // Features Grid
              isMobile
                  ? Column(
                      children: quickActions
                          .map((action) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppColors.spacingM,
                                ),
                                child: _QuickActionCard(action: action),
                              ))
                          .toList(),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: AppColors.spacingL,
                        mainAxisSpacing: AppColors.spacingL,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: quickActions.length,
                      itemBuilder: (context, index) {
                        return _QuickActionCard(action: quickActions[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// Announcements Section
  Widget _buildAnnouncementsSection(
      BuildContext context, LandingPageProvider provider) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveLayout.isMobile(context)
              ? AppColors.spacingXXL
              : 80,
        ),
        color: AppColors.backgroundLight,
        child: _buildMaxWidthContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'Latest Announcements',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppColors.spacingS),
              Text(
                'Stay updated with important news and updates from your school',
                style: GoogleFonts.roboto(
                  fontSize: isMobile ? 16 : 18,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: isMobile ? AppColors.spacingXL : AppColors.spacingXXL),

              // Announcements List
              provider.announcements.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppColors.spacingXXL),
                        child: Text(
                          'No announcements available',
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: provider.announcements.asMap().entries.map((entry) {
                        final index = entry.key;
                        final announcement = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppColors.spacingM,
                          ),
                          child: AnnouncementTile(
                            announcement: announcement,
                            onTap: () => provider.toggleAnnouncement(index),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer Section
  Widget _buildFooter(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isMobile ? AppColors.spacingXL : AppColors.spacingXXL,
        ),
        color: AppColors.textPrimary,
        child: _buildMaxWidthContainer(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'School Portal',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Links (desktop only)
                  if (!isMobile)
                    Row(
                      children: [
                        _FooterLink(label: 'Privacy', onTap: () {}),
                        _FooterLink(label: 'Terms', onTap: () {}),
                        _FooterLink(label: 'Contact', onTap: () {}),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppColors.spacingL),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: AppColors.spacingL),
              Text(
                '© ${DateTime.now().year} School Portal. All rights reserved.',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Navigation Link Widget
class _NavLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Footer Link Widget
class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: GoogleFonts.roboto(
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Quick Action Model
class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final String description;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.description,
  });
}

/// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle quick action tap
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppColors.spacingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(action.icon, color: action.color, size: 36),
              const SizedBox(height: AppColors.spacingM),
              Text(
                action.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                action.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
