import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:clock_app/components/my_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isFinished = false;
  bool isRunning = false;
  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;
  int remainingSeconds = 0;
  int totalSeconds = 0;
  Timer? timer;
  final player = AudioPlayer();

  void startTimer() {
    if (selectedSeconds == 0 && selectedMinutes == 0 && selectedHours == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please set the timer!", 
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 1500),
        )
      );
      return;
    }
    if (remainingSeconds == 0) {
      final hourInSeconds = selectedHours * 60 * 60;
      final minuteInSeconds =selectedMinutes * 60;
      totalSeconds = selectedSeconds + minuteInSeconds + hourInSeconds;
      remainingSeconds = totalSeconds;
    }
    if (timer != null) {
      return;
    }
    setState(() {
      isRunning = true;
      timer = Timer.periodic(
        Duration(seconds: 1),
        (pTimer) {
          setState(() {
            remainingSeconds -= 1;
            if (remainingSeconds == 0) {
              isFinished = true;
              finishTimer();
              return;
            }
          });
        },
      );
    });
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
      timer?.cancel();
      timer = null;
    });
  }

  Future<void> resetTimer() async {
    await player.stop();
    setState(() {
      timer?.cancel();
      timer = null;
      isRunning = false;
      isFinished = false;
      remainingSeconds = 0;
      selectedHours = 0;
      selectedMinutes = 0;
      selectedSeconds = 0;
    });
  }

  Future<void> finishTimer() async {
    isRunning = false;
    isFinished = true;
    timer?.cancel();
    timer = null;
    remainingSeconds = 0;
    selectedHours = 0;
    selectedMinutes = 0;
    selectedSeconds = 0;
    await player.setReleaseMode(
      ReleaseMode.loop
    );
    await player.play(
      AssetSource("sounds/alarm.mp3")
    );
  }
  
  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final formattedHours = hours.toString().padLeft(2, "0");
    final formattedMinutes = minutes.toString().padLeft(2, "0");
    final formattedSeconds = (seconds % 60).toString().padLeft(2, "0");

    return hours > 0 
      ? "$formattedHours:$formattedMinutes:$formattedSeconds"
      : "$formattedMinutes:$formattedSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: isFinished 
        ? _buildTimerFinished() 
        : remainingSeconds == 0 
        ? _buildTimerPicker(context) 
        : _buildTimerRunning(),
      ),
    );
  }

  Widget _buildTimerRunning() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: 1,
                strokeWidth: 5,
                color: Colors.grey,
                constraints: BoxConstraints(
                  minWidth: 320,
                  minHeight: 320
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(
                  end: remainingSeconds / totalSeconds,
                ),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 8,
                    color: remainingSeconds <= 5 ? Colors.red : Colors.green,
                    constraints: BoxConstraints(
                      minWidth: 320,
                      minHeight: 320
                    ),
                  );
                },
              ),
              Text(
                formatTime(remainingSeconds), 
                style: TextStyle(fontSize: 60),
              ),
            ]
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyButton(
              onPressed: resetTimer,
              text: "Reset",
            ),
            MyButton(
              onPressed: isRunning ? pauseTimer : startTimer,
              text: isRunning ? "Pause" : "Resume",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerPicker(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("Hours", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),),
                SizedBox(
                  width: 105,
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 60,
                    onSelectedItemChanged: (index) => selectedHours = index,
                    children: List.generate(100, (index) {
                      return Center(child: Text(index.toString().padLeft(2, "0")));
                    })
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(":", style: TextStyle(fontSize: 30),),
            ),
            Column(
              children: [
                Text(
                  "Minutes", style: TextStyle(
                    color: Colors.grey.shade700, 
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(
                  width: 105,
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 60,
                    onSelectedItemChanged: (index) => selectedMinutes = index,
                    children: List.generate(60, (index) {
                      return Center(child: Text(index.toString().padLeft(2, "0")));
                    })
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(":", style: TextStyle(fontSize: 30)),
            ),
            Column(
              children: [
                Text("Seconds", style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 105,
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 60,
                    onSelectedItemChanged: (index) => selectedSeconds = index,
                    children: List.generate(60, (index) {
                      return Center(child: Text(index.toString().padLeft(2, "0")));
                    })
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 7),
        MyButton(
          onPressed: startTimer,
          text: "Start",
        ),
      ],
    );
  }

  Widget _buildTimerFinished() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Time is up!", 
          style: TextStyle(fontSize: 30, color: Colors.green),
        ),
        SizedBox(height: 200),
        MyButton(
          onPressed: () {resetTimer();},
          text: "Dismiss",
        ),
      ],
    );
  }
}