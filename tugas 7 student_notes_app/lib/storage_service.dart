import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';

class StorageService {
  // Key untuk menyimpan data di SharedPreferences
  static const String _notesKey = 'notes_list';
  static const String _darkModeKey = 'dark_mode';

  // Menyimpan semua catatan
  static Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ubah list Note menjadi list Map
      final List<Map<String, dynamic>> notesMaps =
      notes.map((note) => note.toMap()).toList();

      // Ubah list Map menjadi JSON string
      final String notesJson = jsonEncode(notesMaps);

      // Simpan ke SharedPreferences
      await prefs.setString(_notesKey, notesJson);

      print('✅ Berhasil menyimpan ${notes.length} catatan');
    } catch (e) {
      print('❌ Error saat menyimpan catatan: $e');
    }
  }

  // Mengambil semua catatan
  static Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ambil JSON string dari SharedPreferences
      final String? notesJson = prefs.getString(_notesKey);

      // Jika tidak ada data, return list kosong
      if (notesJson == null) {
        print('ℹ️ Belum ada catatan tersimpan');
        return [];
      }

      // Ubah JSON string menjadi list Map
      final List<dynamic> notesMaps = jsonDecode(notesJson);

      // Ubah list Map menjadi list Note
      final List<Note> notes = notesMaps
          .map((map) => Note.fromMap(map as Map<String, dynamic>))
          .toList();

      print('✅ Berhasil memuat ${notes.length} catatan');
      return notes;
    } catch (e) {
      print('❌ Error saat memuat catatan: $e');
      return [];
    }
  }

  // Menghapus semua catatan
  static Future<void> clearAllNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_notesKey);
      print('✅ Semua catatan telah dihapus');
    } catch (e) {
      print('❌ Error saat menghapus catatan: $e');
    }
  }

  // Menyimpan pengaturan Dark Mode
  static Future<void> saveDarkMode(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDarkMode);
      print('✅ Dark Mode: ${isDarkMode ? "ON" : "OFF"}');
    } catch (e) {
      print('❌ Error saat menyimpan dark mode: $e');
    }
  }

  // Mengambil pengaturan Dark Mode
  static Future<bool> loadDarkMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      return isDarkMode;
    } catch (e) {
      print('❌ Error saat memuat dark mode: $e');
      return false;
    }
  }
}