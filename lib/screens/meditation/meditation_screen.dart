import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mind_care/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'meditation_timer_screen.dart';
import 'package:http/http.dart' as http;

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  bool isPomodoroActive = false;
  int pomodoroMinutes = 25;
  int pomodoroSeconds = 0;
  Timer? pomodoroTimer;

  void startPomodoro() {
    setState(() {
      isPomodoroActive = true;
    });

    pomodoroTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (pomodoroSeconds > 0) {
          pomodoroSeconds--;
        } else if (pomodoroMinutes > 0) {
          pomodoroMinutes--;
          pomodoroSeconds = 59;
        } else {
          //! Timer completed
          pomodoroTimer?.cancel();
          isPomodoroActive = false;
          //! Reset timer
          pomodoroMinutes = 25;
          pomodoroSeconds = 0;
        }
      });
    });
  }

  void resetPomodoro() {
    pomodoroTimer?.cancel();
    setState(() {
      isPomodoroActive = false;
      pomodoroMinutes = 25;
      pomodoroSeconds = 0;
    });
  }

  void startMeditation(int duration) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MeditationTimerScreen(durationInMinutes: duration),
      ),
    );
  }

  Future<void> startMining() async {
    var url = Uri.parse('http://10.0.2.2:5000/start');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      debugPrint('Mining started');
    } else {
      debugPrint('Failed to start mining');
    }
  }

  Future<void> stopMining() async {
    var url = Uri.parse('http://10.0.2.2:5000/stop');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      debugPrint('Mining stopped');
    } else {
      debugPrint('Failed to stop mining');
    }
  }

  @override
  void dispose() {
    pomodoroTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Image.asset(
          "assets/images/meditation.png",
          height: 6.h,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                //! Pomodoro Timer
                Text(
                  'Pomodoro Timer',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                //! Pomodoro timer card
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F2FF),
                    borderRadius: BorderRadius.circular(25),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.primary, width: 8),
                      top: BorderSide(color: AppColors.primary, width: 5),
                      left: BorderSide(color: AppColors.primary, width: 5),
                      right: BorderSide(color: AppColors.primary, width: 12),
                    ),
                  ),
                  child: Column(
                    children: [
                      //!Timer
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "${pomodoroMinutes.toString().padLeft(2, '0')}:${pomodoroSeconds.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF581C87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      //! Start/Reset buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (!isPomodoroActive) {
                                //! When starting the timer, call the mining start endpoint
                                startMining();
                                startPomodoro();
                              } else {
                                //! Optionally pause timer and/or stop mining if needed
                                stopMining();
                                resetPomodoro();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF581C87),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              isPomodoroActive ? 'Reset' : 'Start',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                //! Guided meditation
                Text(
                  'Guided meditation',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 16),
                //! 5 mins card
                GestureDetector(
                  onTap: () => startMeditation(5),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7887D1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.primary, width: 5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              top: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              left: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              right: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                              bottom: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 18, color: Color(0xFF581C87)),
                              const SizedBox(width: 4),
                              Text(
                                '5 mins',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        //! Wind image
                        Image.asset(
                          "assets/images/wind.png",
                          height: 12.h,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                //! 10 mins card
                GestureDetector(
                  onTap: () => startMeditation(10),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFCB6A),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.primary, width: 5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              top: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              left: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              right: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                              bottom: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 18, color: Color(0xFF581C87)),
                              const SizedBox(width: 4),
                              Text(
                                '10 mins',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        //! Lotus image
                        Image.asset(
                          "assets/images/lotus.png",
                          height: 12.h,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                //! 15 mins card
                GestureDetector(
                  onTap: () => startMeditation(15),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D7D83),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: AppColors.primary, width: 5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              top: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              left: BorderSide(
                                color: AppColors.primary,
                                width: 4,
                              ),
                              right: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                              bottom: BorderSide(
                                color: AppColors.primary,
                                width: 10,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 18, color: Color(0xFF581C87)),
                              const SizedBox(width: 4),
                              Text(
                                '15 mins',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        //! sleep image
                        Image.asset(
                          "assets/images/moon.png",
                          height: 12.h,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
