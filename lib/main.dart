import 'package:flutter/material.dart';
import 'package:sar/explore/ex.dart';
import 'package:sar/explore/explore.dart';
import 'package:sar/quiz/screens/dashboard_screen.dart';
import 'package:sar/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaSense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const QuizScreen(),
    );
  }
}
