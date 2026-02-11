// lib/screens/dashboard_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> tasks = [];
  List<String> history = [];
  String aiSuggestion = "";
  final taskController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
    loadHistory();
  }

  void loadTasks() async {
    final data = await StorageService.getTasks();
    setState(() {
      tasks = data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(jsonDecode(e))).toList();
    });
  }

  void loadHistory() async {
    final data = await StorageService.getHistory();
    setState(() {
      history = data;
    });
  }

  void addTask(String task, String time) async {
    final newTask = {"task": task, "time": time};
    tasks.add(newTask);
    await StorageService.saveTasks(tasks);
    setState(() {});
  }

  void clearHistory() async {
    await StorageService.clearHistory();
    setState(() {
      history.clear();
    });
  }

  void logout() async {
    await StorageService.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void getAISuggestion() async {
    final contextData = {
      "tasks": tasks.map((e) => e['task']).toList(),
      "time_block": "evening", // For now static, can update later
      "energy_level": "high",  // For now static
      "location": "home"       // For now static
    };
    final suggestion = await ApiService.getAISuggestion(contextData);
    setState(() {
      aiSuggestion = suggestion;
      history.add(suggestion);
    });
    await StorageService.saveHistory(history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: taskController,
                decoration: const InputDecoration(labelText: "Task Name"),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: "Time (HH:MM)"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    if (taskController.text.isNotEmpty &&
                        timeController.text.isNotEmpty) {
                      addTask(taskController.text, timeController.text);
                      taskController.clear();
                      timeController.clear();
                    }
                  },
                  child: const Text("Add Task")),
              const SizedBox(height: 20),
              const Text(
                "Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...tasks.map((task) => ListTile(
                    title: Text(task['task']),
                    subtitle: Text("Time: ${task['time']}"),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: getAISuggestion,
                  child: const Text("Get AI Suggestion")),
              const SizedBox(height: 10),
              if (aiSuggestion.isNotEmpty)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      aiSuggestion,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              const Text(
                "History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...history.map((h) => ListTile(title: Text(h))),
              if (history.isNotEmpty)
                ElevatedButton(
                    onPressed: clearHistory, child: const Text("Clear History")),
            ],
          ),
        ),
      ),
    );
  }
}
