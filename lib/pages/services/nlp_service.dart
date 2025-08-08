import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NlpService {
  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('backend_ip') ?? 'http://192.168.100.35:5000';
  }

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to analyze sentiment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> sendAudio(String filePath) async {
    try {
      final baseUrl = await getBaseUrl();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/analyze_audio'), // Updated endpoint
      );
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        filePath,
        contentType: MediaType('audio', 'aac'), // Specify AAC content type
      ));
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return jsonDecode(responseData.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to send audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
