class TeacherModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final List<String> subjectIds;
  final List<String> classIds;
  final String qualification;
  final int yearsExperience;

  const TeacherModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.subjectIds,
    required this.classIds,
    required this.qualification,
    required this.yearsExperience,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
  String get displayName => 'Mr/Ms $lastName';
}