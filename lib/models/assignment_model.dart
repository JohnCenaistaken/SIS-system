enum AssignmentPriority { urgent, thisWeek, normal }
enum AssignmentStatus { active, closed, draft }

class AssignmentModel {
  final String id;
  final String title;
  final String subjectId;
  final String classId;
  final String teacherId;
  final String description;
  final DateTime dueDate;
  final DateTime assignedDate;
  final double maxScore;
  final AssignmentPriority priority;
  final AssignmentStatus status;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.classId,
    required this.teacherId,
    required this.description,
    required this.dueDate,
    required this.assignedDate,
    required this.maxScore,
    required this.priority,
    required this.status,
  });

  bool get isOverdue => DateTime.now().isAfter(dueDate);

  String get priorityLabel {
    switch (priority) {
      case AssignmentPriority.urgent:
        return 'Urgent';
      case AssignmentPriority.thisWeek:
        return 'This Week';
      case AssignmentPriority.normal:
        return 'Normal';
    }
  }
}