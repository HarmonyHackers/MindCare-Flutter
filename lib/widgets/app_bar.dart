import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mind_care/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../screens/notification_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
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
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 3.9.h,
            ),
          ),
        ),
      ],
    );
  }
}
