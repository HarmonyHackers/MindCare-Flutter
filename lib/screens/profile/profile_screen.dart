import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_care/screens/fund_transparency/fund_tranparency_page.dart';
import 'package:mind_care/screens/profile/mining_dashboard.dart';
import 'package:mind_care/utils/custom_message_notifier.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../config/colors.dart';
import '../../models/user_model.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          //! Navigate to login screen when logged out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        UserModel? user;
        if (state is Authenticated) {
          user = state.user;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildProfileAvatar(user),
                  const SizedBox(height: 16),
                  _buildUserName(user),
                  const SizedBox(height: 8),
                  _buildUserEmail(user),
                  const SizedBox(height: 40),
                  _buildProfileInfo(context),
                  const SizedBox(height: 40),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileAvatar(UserModel? user) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                user?.photoURL != null && user!.photoURL!.isNotEmpty
                    ? NetworkImage(user.photoURL!)
                    : const AssetImage('assets/images/default_avatar.jpg')
                        as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(UserModel? user) {
    return Text(
      user?.displayName ?? 'Mind Care User',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUserEmail(UserModel? user) {
    return Text(
      user?.email ?? 'No email available',
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    void sendEmail() async {
      final String subject = Uri.encodeComponent("Help & Support Inquiry");
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'mindcareaether@gmail.com',
        query: 'subject=$subject',
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        CustomMessageNotifier.showSnackBar(
          context,
          "Could not launch email",
          onError: false,
        );
      }
    }

    final List<Map<String, dynamic>> items = [
      {
        'icon': Icons.dashboard,
        'title': 'Mining Dashboard',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MiningDashboard(),
            ),
          );
        }
      },
      {
        'icon': Icons.currency_rupee,
        'title': 'Fund Tranparency',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FundTransparencyPage(),
            ),
          );
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'onTap': () {
          sendEmail();
        },
      },
      {
        'icon': Icons.privacy_tip_outlined,
        'title': 'Privacy Policy',
        'onTap': () async {
          final Uri url = Uri.parse(
              "https://docs.google.com/document/d/107309uTfzlDF0BW4LmILnCXePvxzWRPGNlB5a_5SZeQ/edit?tab=t.0");

          try {
            await launchUrl(
              url,
              mode: LaunchMode.inAppBrowserView,
            );
          } catch (e) {
            CustomMessageNotifier.showSnackBar(
              context,
              "Could not launch URL: $e",
              onError: true,
            );
          }
        }
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(items[index]['icon'], color: AppColors.primary),
            title: Text(items[index]['title']),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: items[index]['onTap'],
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _showLogoutConfirmationDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Log Out',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                //! Dispatch the SignOut event to the AuthBloc
                context.read<AuthBloc>().add(SignOut());
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: AppColors.banner),
              ),
            ),
          ],
        );
      },
    );
  }
}
