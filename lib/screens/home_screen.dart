import 'package:flutter/material.dart';
import 'package:mind_care/utils/contants.dart';
import '../config/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/feature_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/video_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's begin healing",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 20),
                _buildFeatureGrid(),
                const SizedBox(height: 30),
                Text(
                  "How are you feeling?",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                const MoodSelector(),
                const SizedBox(height: 30),
                Text(
                  "Daily Videos",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                const VideoSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    final List<Color> cardColors = [
      AppColors.cardPurple,
      AppColors.cardBlue,
      AppColors.cardRed,
      AppColors.cardLavender,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return FeatureCard(
          name: Constants.featureNames[index],
          icon: Constants.featureIcons[index],
          color: cardColors[index],
        );
      },
    );
  }
}
