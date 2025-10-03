// lib/data/leaderboard_data.dart
import '../models/leaderboard_user_model.dart';

final List<LeaderboardUser> leaderboardData = [
  LeaderboardUser(rank: 1, name: 'Walid', level: 12, badges: 8, points: 2850),
  LeaderboardUser(
    rank: 2,
    name: 'Umme Meheroonnesa Mim',
    level: 11,
    badges: 7,
    points: 2640,
  ),
  LeaderboardUser(
    rank: 3,
    name: 'Adnan Shamim',
    level: 10,
    badges: 6,
    points: 2420,
  ),
  LeaderboardUser(
    rank: 4,
    name: 'Shafwat Mahiya',
    level: 1,
    badges: 2,
    points: 50,
    isCurrentUser: true,
  ),
  LeaderboardUser(
    rank: 5,
    name: 'Sazzad hossen Chowdhury',
    level: 2,
    badges: 1,
    points: 310,
  ),
  LeaderboardUser(
    rank: 5,
    name: 'Najia Sultana',
    level: 2,
    badges: 1,
    points: 310,
  ),
  LeaderboardUser(
    rank: 5,
    name: 'Umama Morshed',
    level: 2,
    badges: 1,
    points: 310,
  ),
];
