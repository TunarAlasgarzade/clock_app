import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  Duration time = Duration.zero;
  Timer? timer;

  // start timer function
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

  // pause timer function
  void pauseTimer() {
    setState(() {
      timer?.cancel();
      timer = null;
    });
  }

  // reset timer function
  void resetTimer() {
    pauseTimer();
    setState(() {
      time = Duration.zero;
    });
  }

  // start or pause timer
  void startOrPauseTimer() {
    if (timer == null) {
      startTimer();
    } else {
      pauseTimer();
    }
  }

  // format time
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Stopwarch", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formatTime(), style: TextStyle(fontSize: 60),),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 ElevatedButton(
                  onPressed: () { resetTimer(); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Reset",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {startOrPauseTimer();},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ), 
                  child: Text(
                    timer == null ? "Start" : "Pause", 
                    style: TextStyle(color: Colors.white)
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