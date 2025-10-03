// lib/quiz_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_question.dart';
import 'package:lottie/lottie.dart';
import 'ai_quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // All state variables and initState are the same...
  final AiQuizService _aiQuizService = AiQuizService();
  late Future<List<QuizQuestion>> _aiQuizFuture;

  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _secondsRemaining = 30;
  Timer? _timer;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _showResultScreen = false;
  bool _wasSuccessful = false;

  @override
  void initState() {
    super.initState();
    _aiQuizFuture = _aiQuizService.generateSarQuiz();
  }

  // --- THE FIX IS IN THIS FUNCTION ---
  void _restartQuiz() {
    // Also cancel any old timer that might still be lingering.
    _timer?.cancel();

    setState(() {
      _showResultScreen = false;
      _wasSuccessful = false;
      _currentQuestionIndex = 0;

      // --- ADDED THESE LINES TO FULLY RESET THE STATE ---
      _isAnswered = false; // Allow answering again
      _selectedAnswerIndex = null; // Clear old answer colors
      _secondsRemaining = 30; // Reset the timer display

      // Clear old questions and trigger a new fetch from the AI
      _questions = [];
      _aiQuizFuture = _aiQuizService.generateSarQuiz();
    });
  }

  // All other functions (_startQuiz, _handleAnswer, _resetForNextQuestion, etc.)
  // and all build methods remain exactly the same as before.

  void _startQuiz(List<QuizQuestion> questions) {
    setState(() {
      _questions = questions;
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _handleAnswer(null);
      }
    });
  }

  void _handleAnswer(int? selectedIndex) {
    if (_isAnswered) return;
    _timer?.cancel();
    _isAnswered = true;
    _selectedAnswerIndex = selectedIndex;
    final bool isCorrect =
        selectedIndex == _questions[_currentQuestionIndex].correctAnswerIndex;

    if (isCorrect) {
      setState(() {});
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (isCorrect) {
        if (_currentQuestionIndex < _questions.length - 1) {
          setState(() {
            _currentQuestionIndex++;
            _resetForNextQuestion();
          });
        } else {
          setState(() {
            _currentQuestionIndex++;
            _wasSuccessful = true;
            _showResultScreen = true;
          });
        }
      } else {
        setState(() {
          _wasSuccessful = false;
          _showResultScreen = true;
        });
      }
    });
    setState(() {});
  }

  void _resetForNextQuestion() {
    _isAnswered = false;
    _selectedAnswerIndex = null;
    _secondsRemaining = 30;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ... This entire build method is unchanged ...
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/quiz.png"), // Your image path
            fit: BoxFit.cover, // Make the image cover the entire screen
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<QuizQuestion>>(
            future: _aiQuizFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildGeneratingQuizUI();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (snapshot.hasData) {
                if (_questions.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _startQuiz(snapshot.data!);
                    }
                  });
                  return const Center(child: CircularProgressIndicator());
                }
                return _showResultScreen
                    ? _buildResultScreen()
                    : _buildQuizScreen();
              } else {
                return const Center(child: Text("No quiz available."));
              }
            },
          ),
        ),
      ),
    );
  }

  // --- All the _build... methods are also unchanged ---
  Widget _buildGeneratingQuizUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/ai_thinking.json', width: 200),
          const SizedBox(height: 20),
          const Text(
            "Generating your personalized quiz...",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 90),
          _buildExcitingProgressBar(),
          const SizedBox(height: 24),
          Lottie.asset('assets/satellite.json', height: 150),
          const SizedBox(height: 24),
          _buildQuestionCard(currentQuestion.questionText),
          const SizedBox(height: 10),
          const Text(
            "Choose your Answers",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ...List.generate(currentQuestion.options.length, (index) {
            return _buildOptionItem(index, currentQuestion.options[index]);
          }),
          const Spacer(),
          Text(
            "00 : ${_secondsRemaining.toString().padLeft(2, '0')}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildExcitingProgressBar() {
    double progress =
        _isAnswered &&
            _selectedAnswerIndex ==
                _questions[_currentQuestionIndex].correctAnswerIndex
        ? (_currentQuestionIndex + 1) / _questions.length
        : _currentQuestionIndex / _questions.length;

    double screenWidth = MediaQuery.of(context).size.width - 40;

    return Stack(
      children: [
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          height: 12,
          width: screenWidth * progress,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildOptionItem(int index, String text) {
    Color borderColor = Colors.white;
    if (_isAnswered) {
      if (index == _questions[_currentQuestionIndex].correctAnswerIndex) {
        borderColor = Colors.green;
      } else if (index == _selectedAnswerIndex) {
        borderColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: InkWell(
        onTap: _isAnswered ? null : () => _handleAnswer(index),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderColor, width: 2.5),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFFBC2EB), Color(0xFFA6C1EE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _wasSuccessful
                ? _buildSuccessContent()
                : _buildFailureContent(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        const Text(
          "Congratulations!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Image.asset('assets/badge.png', height: 120),
        const SizedBox(height: 20),
        const Text(
          "You answered correctly and earned +25 KP 🚀",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildResultButton(text: "Learn More", onPressed: () {}),
            _buildResultButton(
              text: "Next ❯",
              isPrimary: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFailureContent() {
    return Column(
      children: [
        const Text(
          "Oops!!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Icon(
          Icons.sentiment_dissatisfied_outlined,
          color: Colors.white,
          size: 120,
        ),
        const SizedBox(height: 20),
        const Text(
          "Try Again",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildResultButton(text: "Learn More", onPressed: () {}),
            _buildResultButton(
              text: "Try Again ↻",
              isPrimary: true,
              onPressed: _restartQuiz,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultButton({
    required String text,
    bool isPrimary = false,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Color(0XFF254682),
        foregroundColor: isPrimary ? Colors.deepPurple : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
