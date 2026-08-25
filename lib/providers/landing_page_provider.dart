import 'package:flutter/foundation.dart';
import 'package:report_portal_boom/models/announcement_model.dart';
import 'package:report_portal_boom/services/sis_service.dart';

class LandingPageProvider with ChangeNotifier {
  final SisService _service = SisService.instance;

  List<AnnouncementModel> _announcements = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;

  List<AnnouncementModel> get announcements => _announcements;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _announcements = await _service.getAnnouncements();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAnnouncements() async {
    _isRefreshing = true;
    notifyListeners();
    try {
      _announcements = await _service.getAnnouncements();
      _error = null;
    } catch (e) {
      _error = 'Failed to refresh: $e';
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> retry() async => initialize();
}