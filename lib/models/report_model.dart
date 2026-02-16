class StudentReport {
  final String studentName;
  final String studentId;
  final String gradeLevel;
  final String schoolYear;
  final String schoolName;
  final DateTime reportDate;
  final List<SubjectGrade> subjects;
  final String? teacherComments;
  final String? principalSignatureUrl;

  StudentReport({
    required this.studentName,
    required this.studentId,
    required this.gradeLevel,
    required this.schoolYear,
    required this.schoolName,
    required this.reportDate,
    required this.subjects,
    this.teacherComments,
    this.principalSignatureUrl,
  });

  // Calculate overall average
  double get overallAverage {
    if (subjects.isEmpty) return 0;
    final total = subjects.fold(
        0.0, (previous, subject) => previous + subject.gradeValue);
    return total / subjects.length;
  }

  // Get letter grade based on average
  String get overallLetterGrade {
    final average = overallAverage;
    if (average >= 90) return 'A';
    if (average >= 80) return 'B';
    if (average >= 70) return 'C';
    if (average >= 60) return 'D';
    return 'F';
  }

  // Get performance comment
  String get performanceComment {
    final average = overallAverage;
    if (average >= 90) return 'Excellent work!';
    if (average >= 80) return 'Good performance';
    if (average >= 70) return 'Satisfactory';
    if (average >= 60) return 'Needs improvement';
    return 'Serious improvement needed';
  }
}

class SubjectGrade {
  final String subjectName;
  final double gradeValue; // 0-100 scale
  final String? teacherComments;
  final String? teacherName;
  String letterGrade;

  SubjectGrade({
    required this.subjectName,
    required this.letterGrade,
    required this.gradeValue,
    this.teacherComments,
    this.teacherName,
  });

  // Convert numeric grade to letter grade
  String get myletterGrade {
    if (gradeValue >= 90) return 'A';
    if (gradeValue >= 80) return 'B';
    if (gradeValue >= 70) return 'C';
    if (gradeValue >= 60) return 'D';
    return 'F';
  }
}
