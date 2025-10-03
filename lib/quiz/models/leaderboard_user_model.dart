class LeaderboardUser {
  final String name;
  final int level;
  final int badges;
  final int points;
  final int rank;
  final bool isCurrentUser;

  LeaderboardUser({
    required this.name,
    required this.level,
    required this.badges,
    required this.points,
    required this.rank,
    this.isCurrentUser = false,
  });
}
