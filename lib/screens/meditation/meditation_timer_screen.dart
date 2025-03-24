import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MeditationTimerScreen extends StatefulWidget {
  final int durationInMinutes;

  const MeditationTimerScreen({super.key, required this.durationInMinutes});

  @override
  State<MeditationTimerScreen> createState() => _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends State<MeditationTimerScreen> {
  late int remainingSeconds;
  Timer? timer;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationInMinutes * 60;
  }

  Future<void> startMining() async {
    //! For android emulators -> http://10.0.2.2:5000/start
    //! iOS Simulator ->	http://127.0.0.1:5000/start
    var url = Uri.parse('http://10.0.2.2:5000/start');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      debugPrint('Mining started');
    } else {
      debugPrint('Failed to start mining');
    }
  }

  Future<void> stopMining() async {
    //! For android emulators -> http://10.0.2.2:5000/stop
    //! iOS Simulator ->	http://127.0.0.1:5000/stop
    var url = Uri.parse('http://10.0.2.2:5000/stop');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      debugPrint('Mining stopped');
    } else {
      debugPrint('Failed to stop mining');
    }
  }

  void startTimer() {
    setState(() {
      isActive = true;
    });

    startMining();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          isActive = false;
          stopMining();
        }
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isActive = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isActive = false;
      remainingSeconds = widget.durationInMinutes * 60;
    });
    stopMining();
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    stopMining();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '${widget.durationInMinutes} Minute Meditation',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Breathe in... Breathe out...',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 60),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: remainingSeconds / (widget.durationInMinutes * 60),
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF581C87)),
                  ),
                ),
                Text(
                  formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF581C87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isActive ? pauseTimer : startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF581C87),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Pause' : 'Start',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
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
    );
  }
}
