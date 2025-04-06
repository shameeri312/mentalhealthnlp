import 'package:url_launcher/url_launcher.dart';

class YouTubeService {
  static const Map<String, String> resources = {
    'Negative': 'https://www.youtube.com/watch?v=relaxation_video_id',
    'Neutral': 'https://www.youtube.com/watch?v=motivation_video_id',
    'Positive': 'https://www.youtube.com/watch?v=happy_video_id',
  };

  static Future<void> launchResource(String sentiment) async {
    final url = resources[sentiment] ?? resources['Neutral']!;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
