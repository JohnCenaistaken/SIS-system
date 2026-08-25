enum AssessmentType { quiz, test, exam, essay, labReport, practical, assignment, project }

class GradeModel {
  final String id;
  final String studentId;
  final String subjectId;
  final String classId;
  final AssessmentType assessmentType;
  final String title;
  final double score;
  final double maxScore;
  final DateTime date;
  final int term;

  /// Links this grade to the ReportModel it was rolled into, if any.
  /// Null for grades saved as a draft (not yet part of a generated report).
  final String? reportId;

  const GradeModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.classId,
    required this.assessmentType,
    required this.title,
    required this.score,
    required this.maxScore,
    required this.date,
    required this.term,
    this.reportId,
  });

  double get percentage => (score / maxScore) * 100;

  String get letterGrade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 75) return 'B+';
    if (p >= 70) return 'B';
    if (p >= 65) return 'C+';
    if (p >= 60) return 'C';
    if (p >= 50) return 'D';
    return 'F';
  }

  bool get isPassing => percentage >= 50;

  /// Returns a copy of this grade, optionally overriding fields.
  /// Useful for attaching a reportId after the fact (e.g. a draft grade
  /// that later gets rolled into a published report).
  GradeModel copyWith({
    String? id,
    String? studentId,
    String? subjectId,
    String? classId,
    AssessmentType? assessmentType,
    String? title,
    double? score,
    double? maxScore,
    DateTime? date,
    int? term,
    String? reportId,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      classId: classId ?? this.classId,
      assessmentType: assessmentType ?? this.assessmentType,
      title: title ?? this.title,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      date: date ?? this.date,
      term: term ?? this.term,
      reportId: reportId ?? this.reportId,
    );
  }
}
