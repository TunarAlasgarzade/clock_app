import 'package:clock_app/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Container(
          width: 33.5,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(
            settingsProvider.sound 
            ? Icons.volume_up 
            : Icons.volume_off
          ),
          title: Text("Sound"),
          trailing: Switch(
            value: settingsProvider.sound, 
            onChanged: (newValue) {
              Provider.of<SettingsProvider>(context, listen: false).toggleSound();
            },
          ),
        ),
        ListTile(
          leading: Icon(
            settingsProvider.vibration 
            ? Icons.vibration 
            : Icons.close,
          ),
          title: Text("Vibration"),
          trailing: Switch(
            value: settingsProvider.vibration, 
            onChanged: (newValue) {
              Provider.of<SettingsProvider>(context, listen: false).toggleVibration();
            },
          ),
        )
      ],
    );
  }
}