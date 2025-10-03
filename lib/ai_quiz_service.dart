// lib/ai_quiz_service.dart

import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- IMPORT DOTENV
import 'quiz_question.dart';

class AiQuizService {
  // --- CHANGE: READ FROM DOTENV INSTEAD OF DART-DEFINE ---
  final String? _apiKey = dotenv.env['GEMINI_API_KEY'];

  Future<List<QuizQuestion>> generateSarQuiz() async {
    // --- UPDATED: Check if the key was loaded from the .env file ---
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw 'GEMINI_API_KEY is not set in your .env file.';
    }

    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey!);

    const prompt = '''
    Generate exactly 3 easy-to-understand quiz questions about Synthetic Aperture Radar (SAR).
    The response must be a valid JSON array. Each object in the array should represent a question and must have these exact keys: "questionText", "options", and "correctAnswerIndex".
    "options" must be an array of 4 strings.
    "correctAnswerIndex" must be an integer from 0 to 3.

    Example format:
    [
      {
        "questionText": "What does SAR stand for?",
        "options": ["Solar Array Radar", "Synthetic Aperture Radar", "Satellite Acoustic Ranging", "System Array Radio"],
        "correctAnswerIndex": 1
      }
    ]
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text
          ?.replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      if (text == null) throw 'AI returned no response.';

      final List<dynamic> jsonList = jsonDecode(text);

      return jsonList.map((jsonData) {
        return QuizQuestion(
          questionText: jsonData['questionText'],
          options: List<String>.from(jsonData['options']),
          correctAnswerIndex: jsonData['correctAnswerIndex'],
        );
      }).toList();
    } catch (e) {
      print('Error generating AI quiz: $e');
      return _getFallbackQuestions();
    }
  }

  List<QuizQuestion> _getFallbackQuestions() {
    // ... (This function remains unchanged)
    return const [
      QuizQuestion(
        questionText:
            'API Error: In SAR images, what does a very dark area over water usually mean?',
        options: [
          'a. Calm water',
          'b. Rough, wavy water',
          'c. An oil spill',
          'd. A boat',
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        questionText:
            'What is a major advantage of SAR over optical satellites?',
        options: [
          'a. It takes color pictures',
          'b. It is cheaper',
          'c. It can see through clouds and at night',
          'd. It is faster',
        ],
        correctAnswerIndex: 2,
      ),
      QuizQuestion(
        questionText:
            'What everyday technology is most similar to how SAR works?',
        options: [
          'a. A camera flash',
          'b. A microphone',
          'c. A GPS navigator',
          'd. Bat echolocation',
        ],
        correctAnswerIndex: 3,
      ),
    ];
  }
}
