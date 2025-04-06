import 'package:http/http.dart' as http;
import 'dart:convert';

class NlpService {
  final String apiKey = 'YOUR_GOOGLE_NLP_API_KEY'; // Replace with your API key

  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    final response = await http.post(
      Uri.parse(
        'https://language.googleapis.com/v1/documents:analyzeSentiment?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "document": {"content": text, "type": "PLAIN_TEXT"},
        "encodingType": "UTF8",
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze sentiment: ${response.statusCode}');
    }
  }

  String getSentimentLabel(double score) {
    if (score > 0.3) return 'Positive';
    if (score < -0.3) return 'Negative';
    return 'Neutral';
  }
}
