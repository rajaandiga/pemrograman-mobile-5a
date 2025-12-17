import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Mahasiswa';
  String _nim = '-';
  String? _profileImagePath;
  // Variabel _readingGoal telah dihapus

  String get name => _name;
  String get nim => _nim;
  String? get profileImagePath => _profileImagePath;
  // Getter readingGoal telah dihapus

  UserProvider() {
    _loadUserData();
  }

  // Load data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('userName') ?? 'Mahasiswa';
    _nim = prefs.getString('userNim') ?? '-';
    _profileImagePath = prefs.getString('profileImage');
    // Loading readingGoal telah dihapus
    notifyListeners();
  }

  // Update profile Nama dan NIM
  Future<void> updateProfile(String name, String nim) async {
    _name = name;
    _nim = nim;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userNim', nim);

    notifyListeners();
  }

  // Update profile image
  Future<void> updateProfileImage(String? imagePath) async {
    _profileImagePath = imagePath;

    final prefs = await SharedPreferences.getInstance();
    if (imagePath != null) {
      await prefs.setString('profileImage', imagePath);
    } else {
      await prefs.remove('profileImage');
    }

    notifyListeners();
  }

// Fungsi updateReadingGoal telah dihapus
}