enum AnnouncementCategory { administration, academics, events, general, sports }
enum AnnouncementAudience { all, students, teachers, grade10, grade11, grade12 }

class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final AnnouncementCategory category;
  final String authorId;
  final DateTime publishedAt;
  final AnnouncementAudience targetAudience;
  final bool isPinned;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.authorId,
    required this.publishedAt,
    required this.targetAudience,
    required this.isPinned,
  });

  String get categoryLabel {
    switch (category) {
      case AnnouncementCategory.administration:
        return 'Administration';
      case AnnouncementCategory.academics:
        return 'Academics';
      case AnnouncementCategory.events:
        return 'Events';
      case AnnouncementCategory.general:
        return 'General';
      case AnnouncementCategory.sports:
        return 'Sports';
    }
  }
}