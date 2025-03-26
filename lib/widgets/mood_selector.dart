import 'package:flutter/material.dart';
import 'package:mind_care/utils/contants.dart';
import '../config/colors.dart';
import '../utils/custom_message_notifier.dart';

class MoodSelector extends StatefulWidget {
  const MoodSelector({super.key});

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        Constants.moods.length,
        (index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              CustomMessageNotifier.showSnackBar(
                context,
                'Mood saved successfully!',
                onSuccess: true,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 5,
              ),
              color: selectedIndex == index
                  ? AppColors.moodYellow
                  : Colors.transparent,
            ),
            child: Image.asset(
              Constants.moods[index].imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
