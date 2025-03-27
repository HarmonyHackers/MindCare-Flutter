import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mind_care/widgets/resource_graph_widget.dart';

class MeditationTimerScreen extends StatefulWidget {
  final int durationInMinutes;

  const MeditationTimerScreen({super.key, required this.durationInMinutes});

  @override
  State<MeditationTimerScreen> createState() => _MeditationTimerScreenState();
}

class _MeditationTimerScreenState extends State<MeditationTimerScreen> {
  late int remainingSeconds;
  Timer? timer;
  Timer? hashrateTimer;
  Timer? resourceTimer;
  bool isActive = false;
  bool isIntervalMode = false;
  String hashrate = "0 H/s";

  //! Lists to store history of CPU and RAM usage
  List<double> cpuData = [];
  List<double> ramData = [];

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.durationInMinutes * 60;
  }

  //! --- Mining and Status Methods ---
  Future<void> startMining() async {
    var url = Uri.parse('http://10.0.2.2:5000/start');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        debugPrint('Mining started');
      } else {
        debugPrint('Failed to start mining: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error starting mining: $e');
    }
  }

  Future<void> stopMining() async {
    var url = Uri.parse('http://10.0.2.2:5000/stop');
    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        debugPrint('Mining stopped');
      } else {
        debugPrint('Failed to stop mining: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error stopping mining: $e');
    }
  }

  Future<void> checkMiningStatus() async {
    var url = Uri.parse('http://10.0.2.2:5000/status');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          isIntervalMode = data["mode"] == "Interval Mode";
          hashrate = "${data["hashrate"]} H/s";
        });
      }
    } catch (e) {
      debugPrint('Error fetching mining status: $e');
    }
  }

  //! --- Fetch Resource Data for the Chart ---
  Future<void> fetchResourceData() async {
    var url = Uri.parse('http://10.0.2.2:5000/resources');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double cpuUsage = (data["cpu"] as num).toDouble();
        double ramUsage = (data["ram"] as num).toDouble();

        setState(() {
          // Append new data and limit history to the last 20 values
          cpuData.add(cpuUsage);
          ramData.add(ramUsage);
          if (cpuData.length > 20) cpuData.removeAt(0);
          if (ramData.length > 20) ramData.removeAt(0);
        });
      }
    } catch (e) {
      debugPrint('Error fetching resource data: $e');
    }
  }

  //! --- Timer Logic Integration ---
  void startTimer() {
    setState(() {
      isActive = true;
    });

    startMining(); // Start mining when timer starts
    checkMiningStatus(); // Initial status check

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        stopMining();
        setState(() {
          isActive = false;
        });
      }
    });

    // Update mining status every 5 seconds
    hashrateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkMiningStatus();
    });

    // Update resource data every 5 seconds to update the chart
    resourceTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchResourceData();
    });
  }

  void pauseTimer() {
    timer?.cancel();
    hashrateTimer?.cancel();
    resourceTimer?.cancel();
    setState(() {
      isActive = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    hashrateTimer?.cancel();
    resourceTimer?.cancel();
    stopMining();

    setState(() {
      isActive = false;
      remainingSeconds = widget.durationInMinutes * 60;
      hashrate = "0 H/s";
      cpuData.clear();
      ramData.clear();
    });
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    hashrateTimer?.cancel();
    resourceTimer?.cancel();
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Breathe in... Breathe out...',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 40),
              //! Timer display
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF581C87)),
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
              //! Resource chart display using Syncfusion Flutter Charts
              const Text(
                'Device Resource Usage (%)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ResourceChart(cpuData: cpuData, ramData: ramData),
              const SizedBox(height: 60),
              //! Control buttons
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
