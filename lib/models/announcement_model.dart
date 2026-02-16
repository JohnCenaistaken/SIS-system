/// Announcement model for SIS system
class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final AnnouncementPriority priority;
  final String? author;
  final bool isExpanded;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    this.author,
    this.isExpanded = false,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    AnnouncementPriority? priority,
    String? author,
    bool? isExpanded,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      author: author ?? this.author,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

enum AnnouncementPriority {
  urgent,
  important,
  normal,
}

extension AnnouncementPriorityExtension on AnnouncementPriority {
  String get label {
    switch (this) {
      case AnnouncementPriority.urgent:
        return 'Urgent';
      case AnnouncementPriority.important:
        return 'Important';
      case AnnouncementPriority.normal:
        return 'Normal';
    }
  }
}
