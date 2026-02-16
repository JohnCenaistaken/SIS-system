/// Quick stats model for SIS dashboard
class QuickStatsModel {
  final double? currentGPA;
  final int upcomingClasses;
  final int pendingAssignments;
  final bool isLoading;

  const QuickStatsModel({
    this.currentGPA,
    required this.upcomingClasses,
    required this.pendingAssignments,
    this.isLoading = false,
  });

  QuickStatsModel copyWith({
    double? currentGPA,
    int? upcomingClasses,
    int? pendingAssignments,
    bool? isLoading,
  }) {
    return QuickStatsModel(
      currentGPA: currentGPA ?? this.currentGPA,
      upcomingClasses: upcomingClasses ?? this.upcomingClasses,
      pendingAssignments: pendingAssignments ?? this.pendingAssignments,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
