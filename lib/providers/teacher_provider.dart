import 'package:flutter/foundation.dart';
import 'package:report_portal_boom/models/class_model.dart';
import 'package:report_portal_boom/models/report_model.dart';
import 'package:report_portal_boom/models/teacher_model.dart';
import 'package:report_portal_boom/services/sis_service.dart';

import '../models/grade_model.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../services/mock_data_service.dart';

class TeacherProvider with ChangeNotifier {
  final SisService _service = SisService.instance;

  TeacherModel? _teacher;
  List<ClassModel> _classes = [];
  List<ReportModel> _reports = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String? _error;

  TeacherModel? get teacher => _teacher;
  List<ClassModel> get classes => _classes;
  List<ReportModel> get reports => _reports;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convenience stat getters with safe fallbacks
  int get studentCount => (_stats['studentCount'] as int?) ?? 0;
  int get classCount => (_stats['classCount'] as int?) ?? 0;
  int get reportCount => (_stats['reportCount'] as int?) ?? 0;

  Future<void> initialize(String teacherId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _service.getTeacherById(teacherId),
        _service.getClassesByTeacher(teacherId),
        _service.getReportsByTeacher(teacherId),
        _service.getTeacherDashboardStats(teacherId),
      ]);

      _teacher = results[0] as TeacherModel?;
      _classes = results[1] as List<ClassModel>;
      _reports = results[2] as List<ReportModel>;
      _stats = results[3] as Map<String, dynamic>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(String teacherId) async {
    await initialize(teacherId);
  }
  List<StudentModel> _selectedClassStudents = [];
  List<SubjectModel> _selectedClassSubjects = [];

  List<StudentModel> get selectedClassStudents =>
      _selectedClassStudents;
  List<SubjectModel> get selectedClassSubjects =>
      _selectedClassSubjects;

  Future<void> loadClassDetails(String classId) async {
    try {
      final results = await Future.wait([
        _service.getStudentsByClass(classId),
        _service.getSubjects(),
      ]);
      _selectedClassStudents =
      results[0] as List<StudentModel>;
      final allSubjects = results[1] as List<SubjectModel>;
      final cls = _classes.firstWhere(
            (c) => c.id == classId,
        orElse: () => _classes.first,
      );
      _selectedClassSubjects = allSubjects
          .where((s) => cls.subjectIds.contains(s.id))
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Finds the grades that back a given report.
  ///
  /// Primary path: grades created after this change carry `reportId`
  /// directly (set in `StudentMarkEntry._saveMarks`), so this is an exact
  /// match — no guessing involved.
  ///
  /// Fallback path: for any grades seeded before `reportId` existed (e.g.
  /// pre-existing mock data), we fall back to matching on classId + term +
  /// the assessment-title portion of the report title, same convention
  /// `StudentMarkEntry` used to build the title:
  /// `'$assessmentTitle — ${class.name}'`. This fallback only kicks in if
  /// the exact-match path finds nothing, and may not resolve correctly if a
  /// class was renamed or two assessments share a title — the reportId
  /// path above doesn't have that ambiguity.
  List<GradeModel> getGradesForReport(ReportModel report) {
    final byId = MockDatabase.grades
        .where((g) => g.reportId == report.id)
        .toList();
    if (byId.isNotEmpty) return byId;

    final assessmentTitle = report.title.split(' — ').first.trim();
    return MockDatabase.grades
        .where((g) =>
    g.classId == report.classId &&
        g.term == report.term &&
        g.title == assessmentTitle &&
        report.studentIds.contains(g.studentId))
        .toList();
  }

  /// Creates a new student from minimal input (first/last name + student
  /// number) and adds them to the given class. Every other StudentModel
  /// field is required but not collected from the "quick add" form, so
  /// they're filled with clearly-marked placeholders the teacher can edit
  /// later once a proper student-edit screen exists.
  ///
  /// Also keeps the in-memory ClassModel.studentIds in sync (by swapping in
  /// a rebuilt ClassModel with the new id appended), since ClassModel has no
  /// copyWith and its fields are final — so we can't mutate it in place.
  Future<StudentModel> addStudentToClass({
    required String classId,
    required String firstName,
    required String lastName,
    required String studentNumber,
  }) async {
    final cls = _classes.firstWhere((c) => c.id == classId);
    final id = 'STU-${DateTime.now().millisecondsSinceEpoch}';

    final student = StudentModel(
      id: id,
      studentNumber: studentNumber,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: DateTime(2010, 1, 1), // placeholder — edit later
      gender: 'Unspecified', // placeholder — edit later
      idNumber: 'PENDING', // placeholder — edit later
      address: 'Not provided', // placeholder — edit later
      guardianName: 'Not provided', // placeholder — edit later
      guardianContact: 'Not provided', // placeholder — edit later
      email:
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}@school.local',
      grade: cls.grade,
      section: cls.section,
      classId: classId,
      status: StudentStatus.active,
    );

    MockDatabase.students.add(student);

    final updatedClass = ClassModel(
      id: cls.id,
      name: cls.name,
      grade: cls.grade,
      section: cls.section,
      teacherId: cls.teacherId,
      subjectIds: cls.subjectIds,
      studentIds: [...cls.studentIds, id],
      term: cls.term,
      academicYear: cls.academicYear,
    );
    final idx = _classes.indexWhere((c) => c.id == classId);
    if (idx != -1) _classes[idx] = updatedClass;

    // Refresh dashboard stats so "Total students" reflects the addition
    if (_teacher != null) {
      _stats = await _service.getTeacherDashboardStats(_teacher!.id);
    }

    notifyListeners();
    return student;
  }

  /// Fetches every grade registered for a class, regardless of term. Used
  /// by the "View Marks" screen — filtering to a specific term (if any) is
  /// left to the caller.
  Future<List<GradeModel>> getGradesForClass(String classId) {
    return _service.getGradesByClass(classId);
  }

  /// Edits a previously-registered mark (e.g. correcting a typo in score or
  /// max score). Since GradeModel's fields are final, this rebuilds the
  /// grade via copyWith and replaces it in place in MockDatabase.grades —
  /// same in-memory-mutation pattern as addStudentToClass uses for
  /// ClassModel. Returns the updated grade, or null if no grade with that
  /// id exists (shouldn't normally happen from the UI).
  Future<GradeModel?> updateGrade({
    required String gradeId,
    required double score,
    required double maxScore,
  }) async {
    final idx = MockDatabase.grades.indexWhere((g) => g.id == gradeId);
    if (idx == -1) return null;

    final updated =
    MockDatabase.grades[idx].copyWith(score: score, maxScore: maxScore);
    MockDatabase.grades[idx] = updated;
    notifyListeners();
    return updated;
  }

  Future<bool> submitGrades(List<GradeModel> grades) async {
    try {
      for (final grade in grades) {
        MockDatabase.grades.add(grade);
      }
      if (_teacher != null) {
        _stats = await _service
            .getTeacherDashboardStats(_teacher!.id);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitReport(ReportModel report) async {
    try {
      MockDatabase.reports.add(report);
      _reports =
      await _service.getReportsByTeacher(_teacher!.id);
      _stats = await _service
          .getTeacherDashboardStats(_teacher!.id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
