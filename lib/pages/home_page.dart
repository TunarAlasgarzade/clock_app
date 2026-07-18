import 'package:flutter/material.dart';
import 'package:clock_app/pages/stopwatch_page.dart';
import 'package:clock_app/pages/timer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const StopwatchPage(),
          const TimerPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.green.withValues(alpha: 0.4),
        backgroundColor: Colors.white,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.timer), 
            label: "Stopwatch",
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_bottom_rounded), 
            label: "Timer",
          )
        ]
      ),
    );
  }
}