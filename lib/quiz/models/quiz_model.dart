class Quiz {
  final String id;
  final String title;
  final String description;
  final String level;
  final int points;
  final String badge;
  final String? prerequisiteQuizId;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.points,
    required this.badge,
    this.prerequisiteQuizId,
  });
}
