import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool sound = true;
  bool vibration = false;

  void toggleSound() {
    sound = !sound;
    saveSound(sound);
    notifyListeners();
  }

  Future<void> loadSound() async {
    final prefs = await SharedPreferences.getInstance();
    sound = prefs.getBool('sound') ?? true;
    notifyListeners();
  }

  Future<void> saveSound(bool sound) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', sound);
  }

  void toggleVibration() {
    vibration = !vibration;
    saveVibration(vibration);
    notifyListeners();
  }

  Future<void> loadVibration() async {
    final prefs = await SharedPreferences.getInstance();
    vibration = prefs.getBool('vibration') ?? false;
    notifyListeners();
  }

  Future<void> saveVibration(bool vibration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration', vibration);
  }
  
  SettingsProvider() {
    loadSound();
    loadVibration();
  }
}