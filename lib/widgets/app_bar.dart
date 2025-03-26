import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_care/blocs/auth/auth_bloc.dart';
import 'package:mind_care/blocs/auth/auth_state.dart';
import 'package:mind_care/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../models/user_model.dart';
import '../screens/profile/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        UserModel? user;
        if (state is Authenticated) {
          user = state.user;
        }
        return AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, top: 12),
              child: FaIcon(
                FontAwesomeIcons.barsStaggered,
                size: 3.2.h,
                color: AppColors.primary,
              ),
            ),
          ),
          centerTitle: true,
          title: Image.asset(
            "assets/images/app_logo.png",
            height: 6.h,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: _buildProfileAvatar(user),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileAvatar(UserModel? user) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[200],
          backgroundImage: user?.photoURL != null && user!.photoURL!.isNotEmpty
              ? NetworkImage(user.photoURL!)
              : const AssetImage('assets/images/default_avatar.jpg')
                  as ImageProvider,
        ),
      ),
    );
  }
}
