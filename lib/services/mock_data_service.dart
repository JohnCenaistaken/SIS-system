/// Central mock database — single source of truth for all mock data.
/// Replace individual maps with real API/DB calls when going to production.
library mock_database;

import '../models/announcement_model.dart';
import '../models/assignment_model.dart';
import '../models/class_model.dart';
import '../models/grade_model.dart';
import '../models/report_model.dart';
import '../models/student_model.dart';
import '../models/subject_model.dart';
import '../models/teacher_model.dart';
import '../models/timetable_model.dart';



class MockDatabase {
  MockDatabase._();

  // ── Students ──────────────────────────────────────────────────────────────

  static final List<StudentModel> students = [
    StudentModel(
      id: 'STU-001',
      studentNumber: '2024-10-042',
      firstName: 'Alex',
      lastName: 'Johnson',
      dateOfBirth: DateTime(2010, 3, 14),
      gender: 'Male',
      idNumber: '1003145678901',
      address: '42 Mhlambanyatsi Rd, Manzini',
      guardianName: 'Mrs. Susan Johnson',
      guardianContact: '+268 7600 1234',
      email: 'alex.johnson@student.school.sz',
      grade: 10,
      section: 'A',
      classId: 'CLS-10A',
      status: StudentStatus.active,
    ),
    StudentModel(
      id: 'STU-002',
      studentNumber: '2024-10-043',
      firstName: 'Sipha',
      lastName: 'Dlamini',
      dateOfBirth: DateTime(2010, 7, 22),
      gender: 'Female',
      idNumber: '1007226789012',
      address: '18 Somhlolo Rd, Mbabane',
      guardianName: 'Mr. Bongani Dlamini',
      guardianContact: '+268 7611 5678',
      email: 'sipha.dlamini@student.school.sz',
      grade: 10,
      section: 'A',
      classId: 'CLS-10A',
      status: StudentStatus.active,
    ),
    StudentModel(
      id: 'STU-003',
      studentNumber: '2024-10-044',
      firstName: 'Lungelo',
      lastName: 'Nkosi',
      dateOfBirth: DateTime(2010, 1, 5),
      gender: 'Male',
      idNumber: '1001056789013',
      address: '7 Mahlanya Rd, Manzini',
      guardianName: 'Mrs. Thembi Nkosi',
      guardianContact: '+268 7622 9012',
      email: 'lungelo.nkosi@student.school.sz',
      grade: 10,
      section: 'A',
      classId: 'CLS-10A',
      status: StudentStatus.active,
    ),
    StudentModel(
      id: 'STU-004',
      studentNumber: '2024-11-021',
      firstName: 'Nomvula',
      lastName: 'Zwane',
      dateOfBirth: DateTime(2009, 9, 17),
      gender: 'Female',
      idNumber: '0909176789014',
      address: '33 Liqhaga Rd, Manzini',
      guardianName: 'Mr. Sipho Zwane',
      guardianContact: '+268 7633 3456',
      email: 'nomvula.zwane@student.school.sz',
      grade: 11,
      section: 'B',
      classId: 'CLS-11B',
      status: StudentStatus.active,
    ),
    StudentModel(
      id: 'STU-005',
      studentNumber: '2024-11-022',
      firstName: 'Thabo',
      lastName: 'Motsa',
      dateOfBirth: DateTime(2009, 4, 30),
      gender: 'Male',
      idNumber: '0904306789015',
      address: '55 Manzini–Mbabane Hwy',
      guardianName: 'Mrs. Lindiwe Motsa',
      guardianContact: '+268 7644 7890',
      email: 'thabo.motsa@student.school.sz',
      grade: 11,
      section: 'B',
      classId: 'CLS-11B',
      status: StudentStatus.active,
    ),
    StudentModel(
      id: 'STU-006',
      studentNumber: '2024-12-011',
      firstName: 'Zanele',
      lastName: 'Shabalala',
      dateOfBirth: DateTime(2008, 12, 2),
      gender: 'Female',
      idNumber: '0812026789016',
      address: '9 Sandlane St, Manzini',
      guardianName: 'Mr. Musa Shabalala',
      guardianContact: '+268 7655 2345',
      email: 'zanele.shabalala@student.school.sz',
      grade: 12,
      section: 'C',
      classId: 'CLS-12C',
      status: StudentStatus.active,
    ),
  ];

  // ── Teachers ──────────────────────────────────────────────────────────────

  static final List<TeacherModel> teachers = [
    TeacherModel(
      id: 'TCH-001',
      firstName: 'Light',
      lastName: 'Yagami',
      email: 'teacher@test.com',
      phone: '+268 7600 0001',
      subjectIds: ['SUB-001'],
      classIds: ['CLS-10A', 'CLS-11B', 'CLS-12C'],
      qualification: 'BSc Mathematics (UNISWA)',
      yearsExperience: 8,
    ),
    TeacherModel(
      id: 'TCH-002',
      firstName: 'Amara',
      lastName: 'Dube',
      email: 'amara.dube@school.sz',
      phone: '+268 7600 0002',
      subjectIds: ['SUB-002'],
      classIds: ['CLS-10A', 'CLS-11B'],
      qualification: 'BSc Physical Science (UNISWA)',
      yearsExperience: 5,
    ),
    TeacherModel(
      id: 'TCH-003',
      firstName: 'Sarah',
      lastName: 'Nkosi',
      email: 'sarah.nkosi@school.sz',
      phone: '+268 7600 0003',
      subjectIds: ['SUB-003'],
      classIds: ['CLS-10A', 'CLS-12C'],
      qualification: 'BA English Literature (UNISWA)',
      yearsExperience: 11,
    ),
    TeacherModel(
      id: 'TCH-004',
      firstName: 'James',
      lastName: 'Moyo',
      email: 'james.moyo@school.sz',
      phone: '+268 7600 0004',
      subjectIds: ['SUB-004'],
      classIds: ['CLS-10A', 'CLS-11B', 'CLS-12C'],
      qualification: 'BA History & Political Science (UNISWA)',
      yearsExperience: 14,
    ),
    TeacherModel(
      id: 'TCH-005',
      firstName: 'Thandi',
      lastName: 'Zulu',
      email: 'thandi.zulu@school.sz',
      phone: '+268 7600 0005',
      subjectIds: ['SUB-005'],
      classIds: ['CLS-10A', 'CLS-11B'],
      qualification: 'BSc Life Sciences (UNISWA)',
      yearsExperience: 6,
    ),
    TeacherModel(
      id: 'TCH-006',
      firstName: 'Sipho',
      lastName: 'Dlamini',
      email: 'sipho.dlamini@school.sz',
      phone: '+268 7600 0006',
      subjectIds: ['SUB-006'],
      classIds: ['CLS-10A', 'CLS-12C'],
      qualification: 'BCom Accounting (UNISWA)',
      yearsExperience: 9,
    ),
  ];

  // ── Subjects ──────────────────────────────────────────────────────────────

  static final List<SubjectModel> subjects = [
    SubjectModel(id: 'SUB-001', name: 'Mathematics', code: 'MATH', teacherId: 'TCH-001', passMark: 50),
    SubjectModel(id: 'SUB-002', name: 'Physical Science', code: 'PHSC', teacherId: 'TCH-002', passMark: 50),
    SubjectModel(id: 'SUB-003', name: 'English', code: 'ENGL', teacherId: 'TCH-003', passMark: 50),
    SubjectModel(id: 'SUB-004', name: 'History', code: 'HIST', teacherId: 'TCH-004', passMark: 50),
    SubjectModel(id: 'SUB-005', name: 'Life Sciences', code: 'LSCI', teacherId: 'TCH-005', passMark: 50),
    SubjectModel(id: 'SUB-006', name: 'Accounting', code: 'ACCT', teacherId: 'TCH-006', passMark: 50),
    SubjectModel(id: 'SUB-007', name: 'Life Orientation', code: 'LORI', teacherId: 'TCH-004', passMark: 50),
  ];

  // ── Classes ───────────────────────────────────────────────────────────────

  static final List<ClassModel> classes = [
    ClassModel(
      id: 'CLS-10A',
      name: 'Grade 10 Math',
      grade: 10,
      section: 'A',
      teacherId: 'TCH-001',
      subjectIds: ['SUB-001', 'SUB-002', 'SUB-003', 'SUB-004', 'SUB-005', 'SUB-006', 'SUB-007'],
      studentIds: ['STU-001', 'STU-002', 'STU-003'],
      term: 2,
      academicYear: '2025–2026',
    ),
    ClassModel(
      id: 'CLS-11B',
      name: 'Grade 11 Math',
      grade: 11,
      section: 'B',
      teacherId: 'TCH-001',
      subjectIds: ['SUB-001', 'SUB-002', 'SUB-003', 'SUB-004', 'SUB-005', 'SUB-007'],
      studentIds: ['STU-004', 'STU-005'],
      term: 2,
      academicYear: '2025–2026',
    ),
    ClassModel(
      id: 'CLS-12C',
      name: 'Grade 12 Calculus',
      grade: 12,
      section: 'C',
      teacherId: 'TCH-001',
      subjectIds: ['SUB-001', 'SUB-003', 'SUB-004', 'SUB-006', 'SUB-007'],
      studentIds: ['STU-006'],
      term: 2,
      academicYear: '2025–2026',
    ),
  ];

  // ── Grades ────────────────────────────────────────────────────────────────

  static final List<GradeModel> grades = [
    // STU-001 grades
    GradeModel(id: 'GRD-001', studentId: 'STU-001', subjectId: 'SUB-001', classId: 'CLS-10A', assessmentType: AssessmentType.quiz, title: 'Quiz: Algebra Basics', score: 90, maxScore: 100, date: DateTime(2026, 4, 10), term: 2),
    GradeModel(id: 'GRD-002', studentId: 'STU-001', subjectId: 'SUB-002', classId: 'CLS-10A', assessmentType: AssessmentType.labReport, title: 'Lab Report: Photosynthesis', score: 87, maxScore: 100, date: DateTime(2026, 4, 12), term: 2),
    GradeModel(id: 'GRD-003', studentId: 'STU-001', subjectId: 'SUB-003', classId: 'CLS-10A', assessmentType: AssessmentType.essay, title: 'Essay: Literary Analysis', score: 95, maxScore: 100, date: DateTime(2026, 4, 15), term: 2),
    GradeModel(id: 'GRD-004', studentId: 'STU-001', subjectId: 'SUB-004', classId: 'CLS-10A', assessmentType: AssessmentType.test, title: 'Test: World War II', score: 82, maxScore: 100, date: DateTime(2026, 4, 18), term: 2),
    GradeModel(id: 'GRD-005', studentId: 'STU-001', subjectId: 'SUB-005', classId: 'CLS-10A', assessmentType: AssessmentType.practical, title: 'Practical: Cell Division', score: 85, maxScore: 100, date: DateTime(2026, 4, 20), term: 2),
    GradeModel(id: 'GRD-006', studentId: 'STU-001', subjectId: 'SUB-006', classId: 'CLS-10A', assessmentType: AssessmentType.test, title: 'Test: Income Statements', score: 74, maxScore: 100, date: DateTime(2026, 4, 22), term: 2),
    // STU-002 grades
    GradeModel(id: 'GRD-007', studentId: 'STU-002', subjectId: 'SUB-001', classId: 'CLS-10A', assessmentType: AssessmentType.quiz, title: 'Quiz: Algebra Basics', score: 78, maxScore: 100, date: DateTime(2026, 4, 10), term: 2),
    GradeModel(id: 'GRD-008', studentId: 'STU-002', subjectId: 'SUB-002', classId: 'CLS-10A', assessmentType: AssessmentType.labReport, title: 'Lab Report: Photosynthesis', score: 92, maxScore: 100, date: DateTime(2026, 4, 12), term: 2),
    GradeModel(id: 'GRD-009', studentId: 'STU-002', subjectId: 'SUB-003', classId: 'CLS-10A', assessmentType: AssessmentType.essay, title: 'Essay: Literary Analysis', score: 88, maxScore: 100, date: DateTime(2026, 4, 15), term: 2),
    // STU-003 grades
    GradeModel(id: 'GRD-010', studentId: 'STU-003', subjectId: 'SUB-001', classId: 'CLS-10A', assessmentType: AssessmentType.quiz, title: 'Quiz: Algebra Basics', score: 65, maxScore: 100, date: DateTime(2026, 4, 10), term: 2),
    GradeModel(id: 'GRD-011', studentId: 'STU-003', subjectId: 'SUB-002', classId: 'CLS-10A', assessmentType: AssessmentType.labReport, title: 'Lab Report: Photosynthesis', score: 71, maxScore: 100, date: DateTime(2026, 4, 12), term: 2),
    // STU-004 grades
    GradeModel(id: 'GRD-012', studentId: 'STU-004', subjectId: 'SUB-001', classId: 'CLS-11B', assessmentType: AssessmentType.test, title: 'Test: Trigonometry', score: 83, maxScore: 100, date: DateTime(2026, 4, 11), term: 2),
    GradeModel(id: 'GRD-013', studentId: 'STU-004', subjectId: 'SUB-002', classId: 'CLS-11B', assessmentType: AssessmentType.test, title: 'Test: Chemical Bonding', score: 76, maxScore: 100, date: DateTime(2026, 4, 14), term: 2),
    // STU-005 grades
    GradeModel(id: 'GRD-014', studentId: 'STU-005', subjectId: 'SUB-001', classId: 'CLS-11B', assessmentType: AssessmentType.test, title: 'Test: Trigonometry', score: 91, maxScore: 100, date: DateTime(2026, 4, 11), term: 2),
    // STU-006 grades
    GradeModel(id: 'GRD-015', studentId: 'STU-006', subjectId: 'SUB-001', classId: 'CLS-12C', assessmentType: AssessmentType.exam, title: 'Mock Exam: Calculus', score: 88, maxScore: 100, date: DateTime(2026, 4, 9), term: 2),
    GradeModel(id: 'GRD-016', studentId: 'STU-006', subjectId: 'SUB-006', classId: 'CLS-12C', assessmentType: AssessmentType.exam, title: 'Mock Exam: Financial Statements', score: 79, maxScore: 100, date: DateTime(2026, 4, 13), term: 2),
  ];

  // ── Assignments ───────────────────────────────────────────────────────────

  static final List<AssignmentModel> assignments = [
    AssignmentModel(
      id: 'ASN-001',
      title: 'Chapter 5 Problem Set',
      subjectId: 'SUB-001',
      classId: 'CLS-10A',
      teacherId: 'TCH-001',
      description: 'Complete all exercises from Chapter 5 on quadratic equations. Show all working.',
      dueDate: DateTime(2026, 5, 12),
      assignedDate: DateTime(2026, 5, 5),
      maxScore: 50,
      priority: AssignmentPriority.urgent,
      status: AssignmentStatus.active,
    ),
    AssignmentModel(
      id: 'ASN-002',
      title: 'Persuasive Essay Draft',
      subjectId: 'SUB-003',
      classId: 'CLS-10A',
      teacherId: 'TCH-003',
      description: 'Write a 600-word persuasive essay on a topic of your choice. Include introduction, body and conclusion.',
      dueDate: DateTime(2026, 5, 16),
      assignedDate: DateTime(2026, 5, 6),
      maxScore: 100,
      priority: AssignmentPriority.thisWeek,
      status: AssignmentStatus.active,
    ),
    AssignmentModel(
      id: 'ASN-003',
      title: 'Lab Report: Titration',
      subjectId: 'SUB-002',
      classId: 'CLS-10A',
      teacherId: 'TCH-002',
      description: 'Write up your findings from the acid-base titration practical. Include hypothesis, method, results and conclusion.',
      dueDate: DateTime(2026, 5, 19),
      assignedDate: DateTime(2026, 5, 7),
      maxScore: 80,
      priority: AssignmentPriority.normal,
      status: AssignmentStatus.active,
    ),
    AssignmentModel(
      id: 'ASN-004',
      title: 'Research: Apartheid Era',
      subjectId: 'SUB-004',
      classId: 'CLS-10A',
      teacherId: 'TCH-004',
      description: 'Research and summarise the key events of the Apartheid era in Southern Africa (1948–1994).',
      dueDate: DateTime(2026, 5, 21),
      assignedDate: DateTime(2026, 5, 8),
      maxScore: 60,
      priority: AssignmentPriority.normal,
      status: AssignmentStatus.active,
    ),
    AssignmentModel(
      id: 'ASN-005',
      title: 'Diagram: Cell Division',
      subjectId: 'SUB-005',
      classId: 'CLS-10A',
      teacherId: 'TCH-005',
      description: 'Draw and label the stages of mitosis and meiosis. Include a comparison table.',
      dueDate: DateTime(2026, 5, 25),
      assignedDate: DateTime(2026, 5, 9),
      maxScore: 40,
      priority: AssignmentPriority.normal,
      status: AssignmentStatus.active,
    ),
    // Grade 11 assignments
    AssignmentModel(
      id: 'ASN-006',
      title: 'Test: Trigonometry',
      subjectId: 'SUB-001',
      classId: 'CLS-11B',
      teacherId: 'TCH-001',
      description: 'In-class test covering sine, cosine and tangent rules.',
      dueDate: DateTime(2026, 5, 13),
      assignedDate: DateTime(2026, 5, 6),
      maxScore: 100,
      priority: AssignmentPriority.urgent,
      status: AssignmentStatus.active,
    ),
  ];

  // ── Announcements ─────────────────────────────────────────────────────────

  static final List<AnnouncementModel> announcements = [
    AnnouncementModel(
      id: 'ANN-001',
      title: 'Term 2 exams begin 20 May 2026',
      body: 'All students must bring their exam timetables. No electronic devices are allowed in exam venues. Students must be seated 10 minutes before the exam starts.',
      category: AnnouncementCategory.administration,
      authorId: 'TCH-004',
      publishedAt: DateTime(2026, 5, 9),
      targetAudience: AnnouncementAudience.all,
      isPinned: true,
    ),
    AnnouncementModel(
      id: 'ANN-002',
      title: 'Parent–teacher meetings scheduled for 15 May',
      body: 'Booking slots are available via the school office. Each meeting is 15 minutes. Please ensure parents are notified in advance and bring their child\'s latest report.',
      category: AnnouncementCategory.academics,
      authorId: 'TCH-003',
      publishedAt: DateTime(2026, 5, 7),
      targetAudience: AnnouncementAudience.all,
      isPinned: false,
    ),
    AnnouncementModel(
      id: 'ANN-003',
      title: 'Sports day postponed to 28 May',
      body: 'Due to adverse weather conditions, sports day has been moved from 21 May to 28 May. All participants should confirm their availability with their PE teacher.',
      category: AnnouncementCategory.events,
      authorId: 'TCH-005',
      publishedAt: DateTime(2026, 5, 4),
      targetAudience: AnnouncementAudience.students,
      isPinned: false,
    ),
    AnnouncementModel(
      id: 'ANN-004',
      title: 'New library books available',
      body: 'The library has received new titles across Science, History and Fiction. Check the catalogue at the reception desk or ask the librarian for assistance.',
      category: AnnouncementCategory.general,
      authorId: 'TCH-003',
      publishedAt: DateTime(2026, 4, 27),
      targetAudience: AnnouncementAudience.students,
      isPinned: false,
    ),
    AnnouncementModel(
      id: 'ANN-005',
      title: 'Grade 12 mock exam results released',
      body: 'Grade 12 students can collect their mock exam result slips from the school office. Please review them with your subject teachers before end of week.',
      category: AnnouncementCategory.academics,
      authorId: 'TCH-001',
      publishedAt: DateTime(2026, 4, 25),
      targetAudience: AnnouncementAudience.grade12,
      isPinned: false,
    ),
  ];

  // ── Timetable ─────────────────────────────────────────────────────────────

  static final List<TimetableEntry> timetable = [
    // Monday
    TimetableEntry(id: 'TT-001', classId: 'CLS-10A', subjectId: 'SUB-001', teacherId: 'TCH-001', day: Weekday.monday, startTime: '07:30', endTime: '08:15', room: 'Room 12'),
    TimetableEntry(id: 'TT-002', classId: 'CLS-10A', subjectId: 'SUB-002', teacherId: 'TCH-002', day: Weekday.monday, startTime: '08:15', endTime: '09:00', room: 'Lab 2'),
    TimetableEntry(id: 'TT-003', classId: 'CLS-10A', subjectId: 'SUB-003', teacherId: 'TCH-003', day: Weekday.monday, startTime: '09:15', endTime: '10:00', room: 'Room 7'),
    TimetableEntry(id: 'TT-004', classId: 'CLS-10A', subjectId: 'SUB-004', teacherId: 'TCH-004', day: Weekday.monday, startTime: '10:00', endTime: '10:45', room: 'Room 4'),
    TimetableEntry(id: 'TT-005', classId: 'CLS-10A', subjectId: 'SUB-005', teacherId: 'TCH-005', day: Weekday.monday, startTime: '10:45', endTime: '11:30', room: 'Lab 1'),
    TimetableEntry(id: 'TT-006', classId: 'CLS-10A', subjectId: 'SUB-006', teacherId: 'TCH-006', day: Weekday.monday, startTime: '12:15', endTime: '13:00', room: 'Room 9'),
    TimetableEntry(id: 'TT-007', classId: 'CLS-10A', subjectId: 'SUB-007', teacherId: 'TCH-004', day: Weekday.monday, startTime: '13:00', endTime: '13:45', room: 'Room 3'),
    // Tuesday
    TimetableEntry(id: 'TT-008', classId: 'CLS-10A', subjectId: 'SUB-003', teacherId: 'TCH-003', day: Weekday.tuesday, startTime: '07:30', endTime: '08:15', room: 'Room 7'),
    TimetableEntry(id: 'TT-009', classId: 'CLS-10A', subjectId: 'SUB-001', teacherId: 'TCH-001', day: Weekday.tuesday, startTime: '08:15', endTime: '09:00', room: 'Room 12'),
    TimetableEntry(id: 'TT-010', classId: 'CLS-10A', subjectId: 'SUB-004', teacherId: 'TCH-004', day: Weekday.tuesday, startTime: '09:15', endTime: '10:00', room: 'Room 4'),
    TimetableEntry(id: 'TT-011', classId: 'CLS-10A', subjectId: 'SUB-006', teacherId: 'TCH-006', day: Weekday.tuesday, startTime: '10:00', endTime: '10:45', room: 'Room 9'),
    TimetableEntry(id: 'TT-012', classId: 'CLS-10A', subjectId: 'SUB-002', teacherId: 'TCH-002', day: Weekday.tuesday, startTime: '10:45', endTime: '11:30', room: 'Lab 2'),
    // Wednesday
    TimetableEntry(id: 'TT-013', classId: 'CLS-10A', subjectId: 'SUB-005', teacherId: 'TCH-005', day: Weekday.wednesday, startTime: '07:30', endTime: '08:15', room: 'Lab 1'),
    TimetableEntry(id: 'TT-014', classId: 'CLS-10A', subjectId: 'SUB-001', teacherId: 'TCH-001', day: Weekday.wednesday, startTime: '08:15', endTime: '09:00', room: 'Room 12'),
    TimetableEntry(id: 'TT-015', classId: 'CLS-10A', subjectId: 'SUB-003', teacherId: 'TCH-003', day: Weekday.wednesday, startTime: '09:15', endTime: '10:00', room: 'Room 7'),
    TimetableEntry(id: 'TT-016', classId: 'CLS-10A', subjectId: 'SUB-002', teacherId: 'TCH-002', day: Weekday.wednesday, startTime: '10:00', endTime: '10:45', room: 'Lab 2'),
    // Thursday
    TimetableEntry(id: 'TT-017', classId: 'CLS-10A', subjectId: 'SUB-004', teacherId: 'TCH-004', day: Weekday.thursday, startTime: '07:30', endTime: '08:15', room: 'Room 4'),
    TimetableEntry(id: 'TT-018', classId: 'CLS-10A', subjectId: 'SUB-006', teacherId: 'TCH-006', day: Weekday.thursday, startTime: '08:15', endTime: '09:00', room: 'Room 9'),
    TimetableEntry(id: 'TT-019', classId: 'CLS-10A', subjectId: 'SUB-005', teacherId: 'TCH-005', day: Weekday.thursday, startTime: '09:15', endTime: '10:00', room: 'Lab 1'),
    TimetableEntry(id: 'TT-020', classId: 'CLS-10A', subjectId: 'SUB-001', teacherId: 'TCH-001', day: Weekday.thursday, startTime: '10:00', endTime: '10:45', room: 'Room 12'),
    // Friday
    TimetableEntry(id: 'TT-021', classId: 'CLS-10A', subjectId: 'SUB-002', teacherId: 'TCH-002', day: Weekday.friday, startTime: '07:30', endTime: '08:15', room: 'Lab 2'),
    TimetableEntry(id: 'TT-022', classId: 'CLS-10A', subjectId: 'SUB-003', teacherId: 'TCH-003', day: Weekday.friday, startTime: '08:15', endTime: '09:00', room: 'Room 7'),
    TimetableEntry(id: 'TT-023', classId: 'CLS-10A', subjectId: 'SUB-007', teacherId: 'TCH-004', day: Weekday.friday, startTime: '09:15', endTime: '10:00', room: 'Room 3'),
    TimetableEntry(id: 'TT-024', classId: 'CLS-10A', subjectId: 'SUB-004', teacherId: 'TCH-004', day: Weekday.friday, startTime: '10:00', endTime: '10:45', room: 'Room 4'),
  ];

  // ── Reports ───────────────────────────────────────────────────────────────

  static final List<ReportModel> reports = [
    ReportModel(
      id: 'RPT-001',
      title: 'Midterm Progress Report',
      classId: 'CLS-10A',
      teacherId: 'TCH-001',
      term: 2,
      academicYear: '2025–2026',
      generatedAt: DateTime(2026, 5, 11),
      studentIds: ['STU-001', 'STU-002', 'STU-003'],
      status: ReportStatus.published,
      type: ReportType.progress,
    ),
    ReportModel(
      id: 'RPT-002',
      title: 'Quarter 1 Grades',
      classId: 'CLS-10A',
      teacherId: 'TCH-001',
      term: 2,
      academicYear: '2025–2026',
      generatedAt: DateTime(2026, 5, 9),
      studentIds: ['STU-001', 'STU-002', 'STU-003'],
      status: ReportStatus.published,
      type: ReportType.termReport,
    ),
    ReportModel(
      id: 'RPT-003',
      title: 'Final Exam Results',
      classId: 'CLS-12C',
      teacherId: 'TCH-001',
      term: 1,
      academicYear: '2025–2026',
      generatedAt: DateTime(2026, 5, 4),
      studentIds: ['STU-006'],
      status: ReportStatus.published,
      type: ReportType.examReport,
    ),
    ReportModel(
      id: 'RPT-004',
      title: 'Parent-Teacher Conference',
      classId: 'CLS-10A',
      teacherId: 'TCH-001',
      term: 2,
      academicYear: '2025–2026',
      generatedAt: DateTime(2026, 4, 27),
      studentIds: ['STU-001', 'STU-002', 'STU-003'],
      status: ReportStatus.draft,
      type: ReportType.progress,
    ),
    ReportModel(
      id: 'RPT-005',
      title: 'Special Assessment',
      classId: 'CLS-11B',
      teacherId: 'TCH-001',
      term: 2,
      academicYear: '2025–2026',
      generatedAt: DateTime(2026, 4, 11),
      studentIds: ['STU-004', 'STU-005'],
      status: ReportStatus.published,
      type: ReportType.assessmentReport,
    ),
  ];


}