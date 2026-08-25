class ClassModel {
  final String id;
  final String name;
  final int grade;
  final String section;
  final String teacherId;
  final List<String> subjectIds;
  final List<String> studentIds;
  final int term;
  final String academicYear;

  const ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.teacherId,
    required this.subjectIds,
    required this.studentIds,
    required this.term,
    required this.academicYear,
  });

  int get studentCount => studentIds.length;
  String get displayName => 'Grade $grade · Section $section';
}