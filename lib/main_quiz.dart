import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sar/explore/explore.dart';
import 'package:sar/quiz/screens/dashboard_screen.dart';
import 'package:sar/quiz_screen.dart';

// --- THE FIX IS IN THESE 3 LINES ---
Future<void> main() async {
  // <-- 1. Mark main as async
  WidgetsFlutterBinding.ensureInitialized(); // <-- 2. Ensure Flutter is ready
  await dotenv.load(fileName: ".env"); // <-- 3. Now you can safely await

  runApp(const RadarQuestQuizApp());
}

class RadarQuestQuizApp extends StatelessWidget {
  const RadarQuestQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadarQuest Quiz',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'sans-serif',
      ),
      debugShowCheckedModeBanner: false,
      home: QuizScreen(),
    );
  }
}
