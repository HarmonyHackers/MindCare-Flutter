import 'package:flutter/material.dart';
import 'package:mind_care/utils/contants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/feature_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/video_section.dart';
import 'chat_screen.dart';
import 'community_screen.dart';
import 'meditation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
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
              const VideoSection(),
              const SizedBox(height: 16),
            ],
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
    final List<Widget> featureScreens = [
      const ChatScreen(),
      const CommunityScreen(),
      const MeditationScreen(),
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
      itemCount: Constants.featureNames.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (index == 2) {
              _openGoogleMaps();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => featureScreens[index],
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: const Border(
                right: BorderSide(width: 10, color: AppColors.primary),
                bottom: BorderSide(width: 10, color: AppColors.primary),
              ),
              borderRadius: BorderRadius.circular(35),
            ),
            child: FeatureCard(
              name: Constants.featureNames[index],
              imagePath: Constants.featureImages[index], // Use imagePath
              color: cardColors[index],
            ),
          ),
        );
      },
    );
  }

  void _openGoogleMaps() async {
    const String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=nearby+psychologists";

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open Google Maps";
    }
  }
}
