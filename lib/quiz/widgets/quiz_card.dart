// lib/widgets/quiz_card.dart
import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../data/quiz_data.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final bool isLocked;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Opacity(
        opacity: isLocked ? 0.65 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          quiz.level,
                          style: TextStyle(
                            color: _getLevelTextColor(quiz.level),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        backgroundColor: _getLevelBackgroundColor(quiz.level),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      if (isLocked)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.lock, size: 18, color: Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quiz.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),

              // --- THIS IS THE FIX FOR THE OVERFLOW ---
              Wrap(
                spacing: 16.0, // Horizontal space
                runSpacing: 8.0, // Vertical space if it wraps to a new line
                children: [
                  _buildInfoItem(
                    Icons.help_outline,
                    '${quiz.description.length} questions',
                  ),
                  _buildInfoItem(Icons.star, '${quiz.points} points'),
                  _buildInfoItem(Icons.military_tech, quiz.badge),
                ],
              ),
              const SizedBox(height: 20),
              if (isLocked)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Complete "${quizzes.firstWhere((q) => q.id == quiz.prerequisiteQuizId).title}" first',
                    style: const TextStyle(
                      color: Color(0xFFE67E22),
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLocked ? null : onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLocked
                        ? Colors.grey.shade300
                        : Colors.blue.shade700,
                    disabledBackgroundColor: Colors.grey.shade200,
                    foregroundColor: isLocked
                        ? Colors.grey.shade600
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: isLocked ? 0 : 2,
                  ),
                  child: isLocked
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Locked',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : const Text(
                          'Start Quiz',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getLevelBackgroundColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFFE8F5E9);
      case 'intermediate':
        return const Color(0xFFFFF3E0);
      case 'advanced':
        return const Color(0xFFFFEBEE);
      default:
        return Colors.grey.shade200;
    }
  }

  Color _getLevelTextColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF2E7D32);
      case 'intermediate':
        return const Color(0xFFEF6C00);
      case 'advanced':
        return const Color(0xFFC62828);
      default:
        return Colors.grey.shade800;
    }
  }
}
