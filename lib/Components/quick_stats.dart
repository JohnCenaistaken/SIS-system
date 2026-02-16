import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:report_portal_boom/models/quick_stats_model.dart';
import 'package:report_portal_boom/constants/app_colors.dart';

/// Quick stats widget with shimmer loading effect
class QuickStatsWidget extends StatelessWidget {
  final QuickStatsModel stats;

  const QuickStatsWidget({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppColors.spacingM),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: stats.isLoading
          ? _buildShimmerLoading(context)
          : _buildStatsContent(context, isDark),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.2),
      highlightColor: Colors.white.withOpacity(0.4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsContent(BuildContext context, bool isDark) {
    return Row(
      children: [
        // GPA Stat
        Expanded(
          child: _StatItem(
            icon: Icons.school,
            label: 'Current GPA',
            value: stats.currentGPA?.toStringAsFixed(2) ?? 'N/A',
            color: Colors.white,
          ),
        ),
        Container(
          width: 1,
          height: 60,
          color: Colors.white.withOpacity(0.3),
        ),
        // Upcoming Classes
        Expanded(
          child: _StatItem(
            icon: Icons.class_,
            label: 'Upcoming',
            value: '${stats.upcomingClasses}',
            color: Colors.white,
          ),
        ),
        Container(
          width: 1,
          height: 60,
          color: Colors.white.withOpacity(0.3),
        ),
        // Pending Assignments
        Expanded(
          child: _StatItem(
            icon: Icons.assignment,
            label: 'Pending',
            value: '${stats.pendingAssignments}',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: AppColors.spacingS),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.9),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
