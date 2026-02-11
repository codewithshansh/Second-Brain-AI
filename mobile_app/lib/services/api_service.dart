import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.44.228.186:8000";

  static Future<String> getSuggestion(
      String task, String energy) async {
    try {
      final now = DateTime.now();

      String timeBlock;
      if (now.hour < 12) {
        timeBlock = "morning";
      } else if (now.hour < 17) {
        timeBlock = "afternoon";
      } else if (now.hour < 21) {
        timeBlock = "evening";
      } else {
        timeBlock = "night";
      }

      final response = await http.post(
        Uri.parse("$baseUrl/suggest"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "location": "home",
          "tasks": [task],
          "time_block": timeBlock,
          "energy_level": energy,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["suggestion"];
      }
      return "AI error ${response.statusCode}";
    } catch (e) {
      return "Connection error";
    }
  }
}
