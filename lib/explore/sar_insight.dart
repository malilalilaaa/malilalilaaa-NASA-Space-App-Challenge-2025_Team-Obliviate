import 'package:flutter/material.dart';

class SarInsight {
  final String title;
  final String description;
  final IconData icon;
  final int points;
  final Color color;

  const SarInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.color,
  });

  // We can pre-define the insights to make them easy to use later
  static const SarInsight subsidence = SarInsight(
    title: 'Subsidence Alert',
    description: 'Sinking by 2.1 cm per year',
    icon: Icons.arrow_downward,
    points: 200,
    color: Colors.purple,
  );

  static const SarInsight microclimate = SarInsight(
    title: 'Microclimate Zone',
    description: '2.8°C warmer than surroundings',
    icon: Icons.thermostat,
    points: 25,
    color: Colors.blue,
  );
}
