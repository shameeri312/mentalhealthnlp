import 'package:url_launcher/url_launcher.dart';

class YouTubeService {
  static const Map<String, String> resources = {
    'Negative':
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Replace with a real relaxation video ID
    'Neutral':
        'https://www.youtube.com/watch?v=cLtiNhAGVus', // Replace with a real neutral video ID
    'Positive':
        'https://www.youtube.com/watch?v=example_positive', // Replace with a real positive video ID
  };

  static Future<void> launchResource(String sentiment) async {
    final url = resources[sentiment] ?? resources['Neutral']!;
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('YouTube Error: $e');
      throw 'Failed to launch video: $e. Please check your network.';
    }
  }
}
