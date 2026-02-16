import 'package:flutter/foundation.dart';
import 'package:report_portal_boom/models/announcement_model.dart';
import 'package:report_portal_boom/models/feature_model.dart';
import 'package:report_portal_boom/models/quick_stats_model.dart';
import 'package:report_portal_boom/services/mock_data_service.dart';

/// Provider for managing landing page state
class LandingPageProvider with ChangeNotifier {
  final MockDataService _dataService = MockDataService.instance;

  // State variables
  List<Feature> _features = [];
  List<Announcement> _announcements = [];
  QuickStatsModel _quickStats = const QuickStatsModel(
    upcomingClasses: 0,
    pendingAssignments: 0,
    isLoading: true,
  );
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  // Getters
  List<Feature> get features => _features;
  List<Announcement> get announcements => _announcements;
  QuickStatsModel get quickStats => _quickStats;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;

  /// Initialize and load all data
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        _loadFeatures(),
        _loadAnnouncements(),
        _loadQuickStats(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load features
  Future<void> _loadFeatures() async {
    try {
      _features = await _dataService.getFeatures();
    } catch (e) {
      _error = 'Failed to load features: $e';
    }
  }

  /// Load announcements
  Future<void> _loadAnnouncements() async {
    try {
      _announcements = await _dataService.getAnnouncements();
    } catch (e) {
      _error = 'Failed to load announcements: $e';
    }
  }

  /// Load quick stats
  Future<void> _loadQuickStats() async {
    try {
      _quickStats = await _dataService.getQuickStats();
    } catch (e) {
      _error = 'Failed to load stats: $e';
    }
  }

  /// Refresh announcements (pull-to-refresh)
  Future<void> refreshAnnouncements() async {
    _isRefreshing = true;
    notifyListeners();

    try {
      _announcements = await _dataService.refreshAnnouncements();
      _error = null;
    } catch (e) {
      _error = 'Failed to refresh announcements: $e';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Toggle announcement expansion
  void toggleAnnouncement(int index) {
    if (index >= 0 && index < _announcements.length) {
      _announcements[index] = _announcements[index].copyWith(
        isExpanded: !_announcements[index].isExpanded,
      );
      notifyListeners();
    }
  }

  /// Retry loading data
  Future<void> retry() async {
    await initialize();
  }
}
