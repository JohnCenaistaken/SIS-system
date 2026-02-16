// Create a sample report (you'll replace this with your actual data)
import '../models/report_model.dart';

final sampleReport = StudentReport(
  studentName: 'Mlungisi Manyats ',
  studentId: 'STU2023001',
  gradeLevel: 'Grade 12',
  schoolYear: '2023-2024',
  schoolName: 'Japan Advanced Nurturing School',
  reportDate: DateTime.now(),
  teacherComments: 'This kid is wack, he is pure trash. He is the core of degeneracy',
  subjects: [
    SubjectGrade(
      subjectName: 'Math',
      gradeValue: 92.5,
      teacherName: 'Mr Ayanakouji',
      teacherComments: 'Excellent problem-solving skills', letterGrade: '',
    ),
    SubjectGrade(
      subjectName: 'English',
      gradeValue: 88.0,
      teacherName: 'Ms Makima',
      teacherComments: 'Strong analytical writing', letterGrade: '',
    ),
    SubjectGrade(
      subjectName: 'P.E',
      gradeValue: 88.0,
      teacherName: 'Mr Itadori',
      teacherComments: 'Small man with explosive abilities', letterGrade: '',
    ),
    SubjectGrade(
      subjectName: 'Chess ',
      gradeValue: 888.0,
      teacherName: 'Mr Akeem',
      teacherComments: 'He tries, he needs to work on his openings', letterGrade: '',
    ),
    SubjectGrade(
      subjectName: 'Accounts',
      gradeValue: 58.0,
      teacherName: 'Ms Mary ',
      teacherComments: 'Poor performance financially', letterGrade: '',
    ),
    // Add more subjects as needed
  ],
);