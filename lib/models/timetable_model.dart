enum Weekday { monday, tuesday, wednesday, thursday, friday }

class TimetableEntry {
  final String id;
  final String classId;
  final String subjectId;
  final String teacherId;
  final Weekday day;
  final String startTime;
  final String endTime;
  final String room;

  const TimetableEntry({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  String get dayLabel {
    switch (day) {
      case Weekday.monday: return 'Monday';
      case Weekday.tuesday: return 'Tuesday';
      case Weekday.wednesday: return 'Wednesday';
      case Weekday.thursday: return 'Thursday';
      case Weekday.friday: return 'Friday';
    }
  }
}