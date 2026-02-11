import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void login() async {
    await StorageService.saveUser(
        name.text, email.text, password.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Sign In",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
                TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
                TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: login, child: const Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
