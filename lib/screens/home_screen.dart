import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_care/screens/daily_videos.dart';
import 'package:mind_care/screens/profile/profile_screen.dart';
import 'package:mind_care/utils/contants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../config/colors.dart';
import '../widgets/app_bar.dart';
import '../widgets/feature_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/video_section.dart';
import 'auth/login_screen.dart';
import 'chat_screen.dart';
import 'expert_booking_screen.dart';
import 'meditation/meditation_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            //! Navigate to login screen when logged out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, //! This clears the navigation stack
            );
          }
        },
        child: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Image.asset("assets/images/app_logo.png"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Profile"),
                      ),
                    ),
                    // const ListTile(
                    //   leading: Icon(Icons.mood),
                    //   title: Text("Mood History"),
                    // ),
                    GestureDetector(
                      onTap: () {
                        //! Show a confirmation dialog
                        _showLogoutConfirmationDialog(context);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text("Log Out"),
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logo_dev_rounded),
                        title: Text('Harmony Hackers'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              const SizedBox(height: 20),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailyVideos(),
                    ),
                  );
                },
                child: const VideoSection(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); //! Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); //! Close the dialog
                //! Dispatch the SignOut event to the AuthBloc
                context.read<AuthBloc>().add(SignOut());
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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
      const ExpertBookingScreen(),
      const SizedBox(),
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
              imagePath: Constants.featureImages[index],
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
