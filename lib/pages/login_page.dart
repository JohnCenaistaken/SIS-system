import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Bloc/auth/auth_provider.dart';
import '../constants/app_colors.dart';

enum _LoginRole { student, teacher }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  _LoginRole? _selectedRole;

  Future<void> _loginAs(_LoginRole role, AuthProvider authProvider) async {
    setState(() => _selectedRole = role);

    final email = role == _LoginRole.student
        ? 'student@test.com'
        : 'teacher@test.com';
    final password = role == _LoginRole.student
        ? 'student123'
        : 'teacher123';

    // Login FIRST, then dismiss — AuthWrapper will rebuild on success
    final success = await authProvider.login(email, password);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sign in to School Portal',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Choose how you'd like to continue",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // Error message
              if (authProvider.error != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          authProvider.error!,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Role cards — tap immediately logs in
              _RoleCard(
                icon: Icons.school_outlined,
                iconColor: AppColors.primaryBlue,
                iconBg: AppColors.primaryBlue.withOpacity(0.1),
                title: 'Student',
                subtitle: 'Access grades, assignments & schedule',
                isSelected: _selectedRole == _LoginRole.student,
                isLoading: authProvider.isLoading &&
                    _selectedRole == _LoginRole.student,
                onTap: authProvider.isLoading
                    ? null
                    : () => _loginAs(_LoginRole.student, authProvider),
              ),
              const SizedBox(height: 12),
              _RoleCard(
                icon: Icons.person_outlined,
                iconColor: const Color(0xFF0F6E56),
                iconBg: const Color(0xFF0F6E56).withOpacity(0.1),
                title: 'Teacher',
                subtitle: 'Manage classes, marks & reports',
                isSelected: _selectedRole == _LoginRole.teacher,
                isLoading: authProvider.isLoading &&
                    _selectedRole == _LoginRole.teacher,
                onTap: authProvider.isLoading
                    ? null
                    : () => _loginAs(_LoginRole.teacher, authProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback? onTap;

  const _RoleCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryBlue
              : Theme.of(context).dividerColor,
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.04)
            : Colors.transparent,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Show spinner while logging in, chevron otherwise
              isLoading
                  ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: iconColor,
                ),
              )
                  : Icon(
                Icons.chevron_right,
                color: isSelected
                    ? AppColors.primaryBlue
                    : Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}