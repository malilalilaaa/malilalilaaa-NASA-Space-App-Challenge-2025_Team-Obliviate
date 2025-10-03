import '../models/quiz_model.dart';

final List<Quiz> quizzes = [
  Quiz(
    id: 'sar_basics',
    title: 'SAR Basics',
    description: 'Learn the fundamentals of Synthetic Aperture Radar',
    level: 'Beginner',
    points: 120,
    badge: 'SAR Explorer',
  ),
  Quiz(
    id: 'disaster_detection',
    title: 'Disaster Detection',
    description: 'How satellites detect natural disasters',
    level: 'Intermediate',
    points: 200,
    badge: 'Disaster Detective',
    prerequisiteQuizId: 'sar_basics',
  ),
  Quiz(
    id: 'earth_monitoring',
    title: 'Earth Monitoring',
    description: 'Understanding Earth observation missions',
    level: 'Advanced',
    points: 300,
    badge: 'Earth Guardian',
    prerequisiteQuizId: 'disaster_detection',
  ),
];
