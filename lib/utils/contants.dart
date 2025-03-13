import 'package:flutter/material.dart';
import '../models/mood.dart';

class Constants {
  static const List<String> featureNames = [
    'Journal',
    'Community',
    'Progress',
    'Meditation'
  ];

  static const List<IconData> featureIcons = [
    Icons.chat_bubble_outline,
    Icons.people_outline,
    Icons.timeline,
    Icons.volunteer_activism
  ];

  static final List<Mood> moods = [
    Mood(name: 'Stressed', icon: Icons.waves),
    Mood(name: 'Sad', icon: Icons.sentiment_dissatisfied),
    Mood(name: 'Neutral', icon: Icons.sentiment_neutral),
    Mood(name: 'Good', icon: Icons.sentiment_satisfied),
    Mood(name: 'Great', icon: Icons.sentiment_very_satisfied),
  ];
}
