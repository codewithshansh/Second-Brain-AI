import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final taskController = TextEditingController();

  String suggestion = "";
  TimeOfDay? selectedTime;

  // 🔹 YOUR LAPTOP IP HERE
  final String baseUrl = "http://10.44.228.186:8000/suggest";

  // ===============================
  // FETCH AI SUGGESTION
  // ===============================
  Future<String> fetchSuggestion() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "location": "home",
        "tasks": [taskController.text]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["suggestion"];
    } else {
      return "Error fetching suggestion";
    }
  }

  // ===============================
  // GET SUGGESTION BUTTON
  // ===============================
  Future<void> getSuggestion() async {
    final result = await fetchSuggestion();

    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList("history") ?? [];
    history.add(result);
    await prefs.setStringList("history", history);

    setState(() {
      suggestion = result;
    });
  }

  // ===============================
  // PICK TIME + SCHEDULE DAILY
  // ===============================
  Future<void> pickTimeAndSchedule() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedTime = time;
    });

    final result = await fetchSuggestion();

    await NotificationService.scheduleDailyNotification(
      hour: time.hour,
      minute: time.minute,
      suggestion: result,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Daily AI Notification Scheduled")),
    );
  }

  // ===============================
  // UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Second Brain")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // SIGN IN
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            // TASK INPUT
            TextField(
              controller: taskController,
              decoration: const InputDecoration(labelText: "Enter today's work"),
            ),

            const SizedBox(height: 20),

            // GET SUGGESTION
            ElevatedButton(
              onPressed: getSuggestion,
              child: const Text("Get AI Suggestion"),
            ),

            const SizedBox(height: 10),

            // SET DAILY TIME
            ElevatedButton(
              onPressed: pickTimeAndSchedule,
              child: const Text("Set Daily AI Time"),
            ),

            const SizedBox(height: 20),

            // SHOW RESULT
            Text(
              suggestion,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
