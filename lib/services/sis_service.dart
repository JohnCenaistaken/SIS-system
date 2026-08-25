

import '../models/announcement_model.dart';
import '../models/assignment_model.dart';
import '../models/class_model.dart';
import '../models/grade_model.dart';
import '../models/report_model.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../models/teacher_model.dart';
import '../models/timetable_model.dart';
import 'mock_data_service.dart';

/// Service layer — all UI code calls this, never MockDatabase directly.
/// Simulates async network delay so it behaves like a real API.
class SisService {
  SisService._();
  static final SisService instance = SisService._();

  static const _delay = Duration(milliseconds: 400);

  // ── Students ──────────────────────────────────────────────────────────────

  Future<List<StudentModel>> getStudents() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockDatabase.students);
  }

  Future<StudentModel?> getStudentById(String id) async {
    await Future.delayed(_delay);
    try {
      return MockDatabase.students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<StudentModel>> getStudentsByClass(String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.students.where((s) => s.classId == classId).toList();
  }

  Future<List<StudentModel>> getStudentsByGrade(int grade) async {
    await Future.delayed(_delay);
    return MockDatabase.students.where((s) => s.grade == grade).toList();
  }

  // ── Teachers ──────────────────────────────────────────────────────────────

  Future<List<TeacherModel>> getTeachers() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockDatabase.teachers);
  }

  Future<TeacherModel?> getTeacherById(String id) async {
    await Future.delayed(_delay);
    try {
      return MockDatabase.teachers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<TeacherModel?> getTeacherByEmail(String email) async {
    await Future.delayed(_delay);
    try {
      return MockDatabase.teachers.firstWhere((t) => t.email == email);
    } catch (_) {
      return null;
    }
  }

  // ── Subjects ──────────────────────────────────────────────────────────────

  Future<List<SubjectModel>> getSubjects() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockDatabase.subjects);
  }

  Future<SubjectModel?> getSubjectById(String id) async {
    await Future.delayed(_delay);
    try {
      return MockDatabase.subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<SubjectModel>> getSubjectsByTeacher(String teacherId) async {
    await Future.delayed(_delay);
    return MockDatabase.subjects.where((s) => s.teacherId == teacherId).toList();
  }

  // ── Classes ───────────────────────────────────────────────────────────────

  Future<List<ClassModel>> getClasses() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockDatabase.classes);
  }

  Future<ClassModel?> getClassById(String id) async {
    await Future.delayed(_delay);
    try {
      return MockDatabase.classes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ClassModel>> getClassesByTeacher(String teacherId) async {
    await Future.delayed(_delay);
    return MockDatabase.classes.where((c) => c.teacherId == teacherId).toList();
  }

  // ── Grades ────────────────────────────────────────────────────────────────

  Future<List<GradeModel>> getGradesByStudent(String studentId) async {
    await Future.delayed(_delay);
    return MockDatabase.grades.where((g) => g.studentId == studentId).toList();
  }

  Future<List<GradeModel>> getGradesByStudentAndTerm(
      String studentId, int term) async {
    await Future.delayed(_delay);
    return MockDatabase.grades
        .where((g) => g.studentId == studentId && g.term == term)
        .toList();
  }

  Future<List<GradeModel>> getGradesByClass(String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.grades.where((g) => g.classId == classId).toList();
  }

  Future<List<GradeModel>> getGradesBySubjectAndClass(
      String subjectId, String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.grades
        .where((g) => g.subjectId == subjectId && g.classId == classId)
        .toList();
  }

  /// Returns average score (0–100) for a student across all grades in a term.
  Future<double> getStudentAverage(String studentId, int term) async {
    await Future.delayed(_delay);
    final grades = MockDatabase.grades
        .where((g) => g.studentId == studentId && g.term == term)
        .toList();
    if (grades.isEmpty) return 0;
    final total = grades.fold<double>(0, (sum, g) => sum + g.percentage);
    return total / grades.length;
  }

  /// Returns subject averages for a student: { subjectId: average% }
  Future<Map<String, double>> getStudentSubjectAverages(
      String studentId, int term) async {
    await Future.delayed(_delay);
    final grades = MockDatabase.grades
        .where((g) => g.studentId == studentId && g.term == term)
        .toList();

    final Map<String, List<double>> grouped = {};
    for (final g in grades) {
      grouped.putIfAbsent(g.subjectId, () => []).add(g.percentage);
    }

    return grouped.map((subjectId, scores) {
      final avg = scores.fold<double>(0, (a, b) => a + b) / scores.length;
      return MapEntry(subjectId, avg);
    });
  }

  /// Returns class average for a subject.
  Future<double> getClassSubjectAverage(
      String classId, String subjectId) async {
    await Future.delayed(_delay);
    final grades = MockDatabase.grades
        .where((g) => g.classId == classId && g.subjectId == subjectId)
        .toList();
    if (grades.isEmpty) return 0;
    final total = grades.fold<double>(0, (sum, g) => sum + g.percentage);
    return total / grades.length;
  }

  // ── Assignments ───────────────────────────────────────────────────────────

  Future<List<AssignmentModel>> getAssignmentsByClass(String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.assignments
        .where((a) => a.classId == classId)
        .toList();
  }

  Future<List<AssignmentModel>> getAssignmentsByTeacher(
      String teacherId) async {
    await Future.delayed(_delay);
    return MockDatabase.assignments
        .where((a) => a.teacherId == teacherId)
        .toList();
  }

  Future<List<AssignmentModel>> getActiveAssignmentsByClass(
      String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.assignments
        .where((a) =>
    a.classId == classId && a.status == AssignmentStatus.active)
        .toList();
  }

  // ── Announcements ─────────────────────────────────────────────────────────

  Future<List<AnnouncementModel>> getAnnouncements() async {
    await Future.delayed(_delay);
    final sorted = [...MockDatabase.announcements]
      ..sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.publishedAt.compareTo(a.publishedAt);
      });
    return sorted;
  }

  Future<List<AnnouncementModel>> getAnnouncementsForAudience(
      AnnouncementAudience audience) async {
    await Future.delayed(_delay);
    return MockDatabase.announcements
        .where((a) =>
    a.targetAudience == audience ||
        a.targetAudience == AnnouncementAudience.all)
        .toList();
  }

  // ── Timetable ─────────────────────────────────────────────────────────────

  Future<List<TimetableEntry>> getTimetableForClass(String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.timetable
        .where((t) => t.classId == classId)
        .toList()
      ..sort((a, b) {
        final dayOrder = a.day.index.compareTo(b.day.index);
        if (dayOrder != 0) return dayOrder;
        return a.startTime.compareTo(b.startTime);
      });
  }

  Future<List<TimetableEntry>> getTimetableForDay(
      String classId, Weekday day) async {
    await Future.delayed(_delay);
    return MockDatabase.timetable
        .where((t) => t.classId == classId && t.day == day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  Future<List<TimetableEntry>> getTimetableForTeacher(
      String teacherId) async {
    await Future.delayed(_delay);
    return MockDatabase.timetable
        .where((t) => t.teacherId == teacherId)
        .toList()
      ..sort((a, b) {
        final dayOrder = a.day.index.compareTo(b.day.index);
        if (dayOrder != 0) return dayOrder;
        return a.startTime.compareTo(b.startTime);
      });
  }

  // ── Reports ───────────────────────────────────────────────────────────────

  Future<List<ReportModel>> getReportsByTeacher(String teacherId) async {
    await Future.delayed(_delay);
    return MockDatabase.reports
        .where((r) => r.teacherId == teacherId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  Future<List<ReportModel>> getReportsByClass(String classId) async {
    await Future.delayed(_delay);
    return MockDatabase.reports
        .where((r) => r.classId == classId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  Future<List<ReportModel>> getReportsByStudent(String studentId) async {
    await Future.delayed(_delay);
    return MockDatabase.reports
        .where((r) => r.studentIds.contains(studentId))
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  // ── Summary helpers (used by dashboards) ─────────────────────────────────

  /// Teacher dashboard stats
  Future<Map<String, dynamic>> getTeacherDashboardStats(
      String teacherId) async {
    await Future.delayed(_delay);
    final classes = MockDatabase.classes
        .where((c) => c.teacherId == teacherId)
        .toList();
    final studentCount = classes.fold<int>(
        0, (sum, c) => sum + c.studentIds.length);
    final reports = MockDatabase.reports
        .where((r) => r.teacherId == teacherId)
        .length;

    return {
      'classCount': classes.length,
      'studentCount': studentCount,
      'reportCount': reports,
    };
  }

  /// Student dashboard stats
  Future<Map<String, dynamic>> getStudentDashboardStats(
      String studentId, int term) async {
    await Future.delayed(_delay);
    final grades = MockDatabase.grades
        .where((g) => g.studentId == studentId && g.term == term)
        .toList();

    final avg = grades.isEmpty
        ? 0.0
        : grades.fold<double>(0, (s, g) => s + g.percentage) / grades.length;

    final gpa = (avg / 100 * 4).clamp(0, 4);

    final assignments = MockDatabase.assignments
        .where((a) =>
    MockDatabase.classes
        .firstWhere(
          (c) => c.studentIds.contains(studentId),
      orElse: () => MockDatabase.classes.first,
    )
        .id ==
        a.classId &&
        a.status == AssignmentStatus.active)
        .length;

    return {
      'gpa': gpa.toStringAsFixed(1),
      'average': avg.toStringAsFixed(0),
      'pendingAssignments': assignments,
      'gradeCount': grades.length,
    };
  }
}