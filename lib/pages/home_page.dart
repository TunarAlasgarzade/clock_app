import 'package:clock_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:clock_app/pages/stopwatch_page.dart';
import 'package:clock_app/pages/timer_page.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
        title: Text(
          selectedIndex == 0 ? "Stopwarch" : "Timer", 
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            }, 
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
              ? Icons.wb_sunny 
              : Icons.nightlight_round, 
              color: Colors.white,
            )
          )
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const StopwatchPage(),
          const TimerPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.green.withValues(alpha: 0.4),
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.timer, color: Theme.of(context).colorScheme.onSurface), 
            label: "Stopwatch",
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_bottom_rounded, color: Theme.of(context).colorScheme.onSurface), 
            label: "Timer",
          )
        ]
      ),
    );
  }
}