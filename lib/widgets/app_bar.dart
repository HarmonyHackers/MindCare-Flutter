import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset(
            "assets/images/menu.png",
            height: 4.h,
          ),
        ),
      ),
      centerTitle: true,
      title: Image.asset(
        "assets/images/app_name.png",
        height: 6.h,
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Image.asset(
              "assets/images/bell-notification-outline.png",
              height: 4.h,
            ),
          ),
        ),
      ],
    );
  }
}
