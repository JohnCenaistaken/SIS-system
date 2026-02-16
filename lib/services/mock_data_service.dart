import 'package:report_portal_boom/models/announcement_model.dart';
import 'package:report_portal_boom/models/feature_model.dart';
import 'package:report_portal_boom/models/quick_stats_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Mock data service for SIS landing page
/// Simulates API calls with delays
class MockDataService {
  MockDataService._();
  static final MockDataService instance = MockDataService._();

  /// Simulate network delay
  Future<void> _delay([int milliseconds = 1000]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Get feature list
  Future<List<Feature>> getFeatures() async {
    await _delay(500);
    return [
      Feature(
        id: '1',
        title: 'Grade Tracking',
        description: 'View and track your academic performance with detailed grade analytics',
        icon: Icons.assessment,
        iconColor: const Color(0xFF1A56DB),
      ),
      Feature(
        id: '2',
        title: 'Course Registration',
        description: 'Register for courses, manage your schedule, and plan your academic journey',
        icon: Icons.book,
        iconColor: const Color(0xFF10B981),
      ),
      Feature(
        id: '3',
        title: 'Attendance Monitoring',
        description: 'Track your attendance records and stay updated with class participation',
        icon: Icons.check_circle,
        iconColor: const Color(0xFFF59E0B),
      ),
      Feature(
        id: '4',
        title: 'Academic Calendar',
        description: 'Access important dates, deadlines, and academic events in one place',
        icon: Icons.calendar_today,
        iconColor: const Color(0xFFEF4444),
      ),
    ];
  }

  /// Get announcements
  Future<List<Announcement>> getAnnouncements() async {
    await _delay(800);
    return [
      Announcement(
        id: '1',
        title: 'Final Exam Schedule Released',
        content:
            'The final examination schedule for Spring 2024 has been released. Please check your student portal for detailed timings and room assignments. All students are required to bring their student ID cards.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        priority: AnnouncementPriority.urgent,
        author: 'Academic Affairs',
      ),
      Announcement(
        id: '2',
        title: 'Course Registration Opens Next Week',
        content:
            'Course registration for Fall 2024 semester will open on Monday, March 18th at 9:00 AM. Please ensure all prerequisites are met before registering. Contact your academic advisor for assistance.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        priority: AnnouncementPriority.important,
        author: 'Registrar Office',
      ),
      Announcement(
        id: '3',
        title: 'Library Extended Hours',
        content:
            'The main library will have extended hours during exam period. Hours: Monday-Friday 7:00 AM - 11:00 PM, Saturday-Sunday 9:00 AM - 9:00 PM.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        priority: AnnouncementPriority.normal,
        author: 'Library Services',
      ),
      Announcement(
        id: '4',
        title: 'Scholarship Application Deadline',
        content:
            'Applications for merit-based scholarships are now open. Deadline: April 15th, 2024. Visit the financial aid office or check the portal for more information.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        priority: AnnouncementPriority.important,
        author: 'Financial Aid',
      ),
    ];
  }

  /// Get quick stats
  Future<QuickStatsModel> getQuickStats() async {
    await _delay(600);
    return const QuickStatsModel(
      currentGPA: 3.75,
      upcomingClasses: 3,
      pendingAssignments: 5,
    );
  }

  /// Refresh announcements (simulate pull-to-refresh)
  Future<List<Announcement>> refreshAnnouncements() async {
    await _delay(1000);
    return getAnnouncements();
  }
}
