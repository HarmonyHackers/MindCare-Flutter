import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../config/colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 6.h,
            ),
            const SizedBox(height: 16),
            Text(
              "Nothing here!!!",
              style: GoogleFonts.kodchasan(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
