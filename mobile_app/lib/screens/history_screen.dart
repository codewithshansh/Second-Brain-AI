import 'package:flutter/material.dart';
import '../utils/storage.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    tasks = await StorageService.loadTasks();
    setState(() {});
  }

  void deleteTask(int index) async {
    tasks.removeAt(index);
    await StorageService.saveTasks(tasks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(tasks[i]["task"]),
            subtitle: Text(tasks[i]["suggestion"]),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteTask(i)),
          );
        },
      ),
    );
  }
}
