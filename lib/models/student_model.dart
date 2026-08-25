enum StudentStatus { active, inactive, suspended, transferred }

class StudentModel {
  final String id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String gender;
  final String idNumber;
  final String address;
  final String guardianName;
  final String guardianContact;
  final String email;
  final int grade;
  final String section;
  final String classId;
  final StudentStatus status;

  const StudentModel({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.idNumber,
    required this.address,
    required this.guardianName,
    required this.guardianContact,
    required this.email,
    required this.grade,
    required this.section,
    required this.classId,
    required this.status,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
  String get gradeSection => 'Grade $grade · Section $section';
}