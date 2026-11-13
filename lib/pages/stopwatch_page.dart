import 'dart:async';
import 'package:clock_app/components/my_button.dart';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Duration time = Duration.zero;
  Timer? timer;

  void startTimer() {
    if (timer != null) {
      return;
    }
    setState(() {
      timer = Timer.periodic(
        Duration(milliseconds: 10),
        (timer) {
          setState(() {
            time += Duration(milliseconds: 10);
          });
        },
      );
    });
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
      timer = null;
    });
  }

  void resetTimer() {
    pauseTimer();
    setState(() {
      time = Duration.zero;
    });
  }

  void startOrPauseTimer() {
    if (timer == null) {
      startTimer();
    } else {
      pauseTimer();
    }
  }

  String formatTime() {
    final hours = time.inHours;
    final formattedHours = hours.toString().padLeft(2, "0");
    final minutes = time.inMinutes % 60;
    final formattedMinutes = minutes.toString().padLeft(2, "0");
    final seconds = time.inSeconds % 60;
    final formattedSeconds = seconds.toString().padLeft(2, "0");
    final milliseconds = time.inMilliseconds % 1000;
    final formattedMilliseconds = milliseconds.toString().padLeft(3, "0");
    if (hours > 0) {
      return "$formattedHours:$formattedMinutes:$formattedSeconds.$formattedMilliseconds";
    } else {
      return "$formattedMinutes:$formattedSeconds.$formattedMilliseconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formatTime(), style: TextStyle(fontSize: 60)),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (time != Duration.zero)
                  MyButton(
                    onPressed: resetTimer,
                    text: "Reset",
                  ),
                MyButton(
                  onPressed: startOrPauseTimer,
                  text: timer == null ? "Start" : "Stop",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}