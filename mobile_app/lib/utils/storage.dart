import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // LOGIN
  static Future<void> saveUser(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("name", name);
    await prefs.setString("email", email);
    await prefs.setString("password", password);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
  }

  // TASK STORAGE
  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = tasks.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList("tasks", encoded);
  }

  static Future<List<Map<String, dynamic>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("tasks") ?? [];

    return data
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }
}
