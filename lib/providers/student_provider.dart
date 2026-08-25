import 'package:flutter/foundation.dart';
import 'package:report_portal_boom/models/announcement_model.dart';
import 'package:report_portal_boom/models/assignment_model.dart';
import 'package:report_portal_boom/models/grade_model.dart';
import 'package:report_portal_boom/models/student_model.dart';
import 'package:report_portal_boom/models/subject_model.dart';
import 'package:report_portal_boom/models/timetable_model.dart';
import 'package:report_portal_boom/services/sis_service.dart';

class StudentProvider with ChangeNotifier {
  final SisService _service = SisService.instance;

  StudentModel? _student;
  List<GradeModel> _grades = [];
  Map<String, double> _subjectAverages = {};
  List<SubjectModel> _subjects = [];
  List<AssignmentModel> _assignments = [];
  List<TimetableEntry> _timetable = [];
  List<AnnouncementModel> _announcements = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String? _error;

  StudentModel? get student => _student;
  List<GradeModel> get grades => _grades;
  Map<String, double> get subjectAverages => _subjectAverages;
  List<SubjectModel> get subjects => _subjects;
  List<AssignmentModel> get assignments => _assignments;
  List<TimetableEntry> get timetable => _timetable;
  List<AnnouncementModel> get announcements => _announcements;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convenience stat getters
  String get gpa => (_stats['gpa'] as String?) ?? '0.0';
  String get average => (_stats['average'] as String?) ?? '0';
  int get pendingAssignments =>
      (_stats['pendingAssignments'] as int?) ?? 0;

  Future<void> initialize(String studentId, String classId,
      {int term = 2}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getStudentById(studentId),
        _service.getGradesByStudentAndTerm(studentId, term),
        _service.getStudentSubjectAverages(studentId, term),
        _service.getSubjects(),
        _service.getActiveAssignmentsByClass(classId),
        _service.getTimetableForClass(classId),
        _service.getAnnouncementsForAudience(AnnouncementAudience.students),
        _service.getStudentDashboardStats(studentId, term),
      ]);

      _student = results[0] as StudentModel?;
      _grades = results[1] as List<GradeModel>;
      _subjectAverages = results[2] as Map<String, double>;
      _subjects = results[3] as List<SubjectModel>;
      _assignments = results[4] as List<AssignmentModel>;
      _timetable = results[5] as List<TimetableEntry>;
      _announcements = results[6] as List<AnnouncementModel>;
      _stats = results[7] as Map<String, dynamic>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String studentId, String classId,
      {int term = 2}) async {
    await initialize(studentId, classId, term: term);
  }

  /// Returns the subject name for a given subjectId
  String subjectName(String subjectId) {
    try {
      return _subjects.firstWhere((s) => s.id == subjectId).name;
    } catch (_) {
      return subjectId;
    }
  }

  /// Returns grades sorted by most recent first
  List<GradeModel> get recentGrades {
    final sorted = [..._grades]
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  /// Returns upcoming assignments sorted by due date
  List<AssignmentModel> get upcomingAssignments {
    final sorted = [..._assignments]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return sorted;
  }
}