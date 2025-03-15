import 'package:mind_care/models/mood.dart';

class Constants {
  static const List<String> featureNames = [
    'Journal',
    'Community',
    'Progress',
    'Meditation'
  ];

  static const List<String> featureImages = [
    // Image paths
    'assets/images/chat-rounded.png',
    'assets/images/people-community.png',
    'assets/images/map-marker-path.png',
    'assets/images/hands-praying.png',
  ];

  static final List<Mood> moods = [
    Mood(name: 'Stressed', imagePath: 'assets/images/Mood_1.png'),
    Mood(name: 'Sad', imagePath: 'assets/images/Mood_2.png'),
    Mood(name: 'Neutral', imagePath: 'assets/images/Mood_3.png'),
    Mood(name: 'Good', imagePath: 'assets/images/Mood_4.png'),
    Mood(name: 'Great', imagePath: 'assets/images/Mood_5.png'),
  ];
}
