// lib/quiz_question.dart

class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}
