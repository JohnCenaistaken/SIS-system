enum ReportStatus { draft, published, archived }
enum ReportType { progress, termReport, examReport, assessmentReport }

class ReportModel {
  final String id;
  final String title;
  final String classId;
  final String teacherId;
  final int term;
  final String academicYear;
  final DateTime generatedAt;
  final List<String> studentIds;
  final ReportStatus status;
  final ReportType type;

  const ReportModel({
    required this.id,
    required this.title,
    required this.classId,
    required this.teacherId,
    required this.term,
    required this.academicYear,
    required this.generatedAt,
    required this.studentIds,
    required this.status,
    required this.type,
  });

  String get statusLabel {
    switch (status) {
      case ReportStatus.draft: return 'Draft';
      case ReportStatus.published: return 'Published';
      case ReportStatus.archived: return 'Archived';
    }
  }
}