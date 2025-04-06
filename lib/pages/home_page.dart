import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';
import 'package:mental_health_nlp/utils/emotion_face.dart';
import 'package:mental_health_nlp/utils/exercises_list.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Define exercises for the Exercises section
  final List<String> exercises = [
    'Deep Breathing Exercise',
    'Mindful Walking',
    'Progressive Muscle Relaxation',
    'Journaling for Emotional Release',
    'Guided Meditation',
    'Positive Affirmations',
    'Stretching Routine',
    'Gratitude Exercise',
    'Light Yoga Poses',
  ];

  // Define video links for each mood
  void showVideoDialog(String mood) {
    List<String> videoLinks = [];

    if (mood == 'Fine') {
      videoLinks = [
        "https://www.youtube.com/watch?v=qKcRUOWYQ9w",
        "https://www.youtube.com/watch?v=yo1pJ_D-H3M",
        "https://www.youtube.com/watch?v=ZjsUNm6xj_E",
      ];
    } else if (mood == 'Bad') {
      videoLinks = [
        "https://www.youtube.com/watch?v=INkEEV2zch4",
        "https://www.youtube.com/watch?v=Mnj1VU1VY8A",
        "https://www.youtube.com/watch?v=5xFsuvQ-aAQ",
      ];
    } else if (mood == 'Well') {
      videoLinks = [
        "https://www.youtube.com/watch?v=5mFTXbZzOAE",
        "https://www.youtube.com/watch?v=Ido0lHOFQEY",
        "https://www.youtube.com/watch?v=nfWlot6h_JM",
      ];
    } else if (mood == 'Excellent') {
      videoLinks = [
        "https://www.youtube.com/watch?v=X_cHhr9BecU",
        "https://www.youtube.com/watch?v=L_jWHffIx5E",
      ];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Recommended videos for \"$mood\" mood"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: videoLinks.length,
            itemBuilder: (context, index) {
              final url = videoLinks[index];
              final videoId = Uri.parse(url).queryParameters['v'];
              final thumbnailUrl = videoId != null
                  ? 'https://img.youtube.com/vi/$videoId/0.jpg'
                  : null;

              return GestureDetector(
                onTap: () => launchUrl(Uri.parse(url)),
                child: Card(
                  color: Colors.blue[50],
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (thumbnailUrl != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.network(
                            thumbnailUrl,
                            width: 100,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Video ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Show exercises dialog
  void showExerciseDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Available Exercises"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return GestureDetector(
                onTap: () {
                  // Add action when exercise is tapped (e.g., open a guide or video)
                  print("Selected exercise: $exercise");
                },
                child: Card(
                  color: Colors.blue[50],
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}. $exercise',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.play_arrow),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionColumn(IconData icon, String mood) {
    return GestureDetector(
      onTap: () => showVideoDialog(mood),
      child: Column(
        children: [
          EmotionFace(emotionIcon: icon),
          const SizedBox(height: 10),
          Text(mood, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => signout(),
        backgroundColor: const Color(0xFF2176FF),
        foregroundColor: Colors.white,
        child: const Icon(Icons.logout_rounded),
      ),
      backgroundColor: const Color(0xFF2176FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section (unchanged)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${user?.displayName ?? 'Dear'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user!.email!,
                        style: TextStyle(color: Colors.blue[100]),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Search Bar (unchanged)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // "How do you feel?" Section
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'How do you feel?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.white),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Emotion Icons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEmotionColumn(Icons.sentiment_satisfied, 'Fine'),
                  _buildEmotionColumn(Icons.sentiment_dissatisfied, 'Bad'),
                  _buildEmotionColumn(Icons.sentiment_neutral, 'Well'),
                  _buildEmotionColumn(
                    Icons.sentiment_very_satisfied,
                    'Excellent',
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Chatbot Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatBotScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF2176FF),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Talk to Chatbot",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Expanded Bottom Section with Exercises
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Exercises',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: showExerciseDialog, // Trigger exercise dialog
                          child:
                              const Icon(Icons.more_horiz, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child:
                          ExerciseList(), // Assuming ExerciseList is a widget
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
