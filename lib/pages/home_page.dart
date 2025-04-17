import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/all_exercises_page.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';
import 'package:mental_health_nlp/utils/base_scaffold.dart';
import 'package:mental_health_nlp/utils/emotion_face.dart';
import 'package:mental_health_nlp/utils/exercises_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State {
  final user = FirebaseAuth.instance.currentUser;

  void showMoodDialog(
      String mood, String description, List suggestedExercises) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Mood: $mood"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Suggested Exercises:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...suggestedExercises.map((exercise) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '- $exercise',
                        style: const TextStyle(fontSize: 16),
                      ),
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionColumn(String imagePath, String mood, String description,
      List suggestedExercises) {
    return GestureDetector(
      onTap: () => showMoodDialog(mood, description, suggestedExercises),
      child: Column(
        children: [
          EmotionFace(imagePath: imagePath),
          const SizedBox(height: 10),
          Text(mood, style: const TextStyle(fontSize: 16, color: Colors.black)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 0,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'How do you feel?',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllExercisesPage()),
                        );
                      },
                      child: const Text(
                        'more',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEmotionColumn(
                      'assets/sad.png',
                      'Sad',
                      'Feeling down or overwhelmed? This mood might indicate sadness, stress, or a sense of hopelessness. It could be triggered by personal challenges, loss, or external pressures. Taking time to process these emotions can be beneficial.',
                      [
                        'Deep Breathing Exercise',
                        'Journaling for Emotional Release',
                        'Guided Meditation',
                        'Progressive Muscle Relaxation',
                        'Visualization Technique',
                      ],
                    ),
                    _buildEmotionColumn(
                      'assets/disappointed.png',
                      'Confused',
                      'Feeling let down or frustrated? This mood might stem from unmet expectations, setbacks, or minor failures. It’s a natural response that can be eased with self-compassion and gentle activities.',
                      [
                        'Mindful Walking',
                        'Progressive Muscle Relaxation',
                        'Positive Affirmations',
                        'Stretching Routine',
                        'Gratitude Exercise',
                      ],
                    ),
                    _buildEmotionColumn(
                      'assets/neutral.png',
                      'Neutral',
                      'Feeling balanced but not strongly emotional? This state reflects a calm or indifferent mindset, possibly after a period of intensity. It’s an opportunity to maintain equilibrium and build resilience.',
                      [
                        'Stretching Routine',
                        'Gratitude Exercise',
                        'Light Yoga Poses',
                        'Body Scan Meditation',
                        'Nature Walk',
                      ],
                    ),
                    _buildEmotionColumn(
                      'assets/happy.png',
                      'Happy',
                      'Feeling joyful and content? This positive mood might arise from achievements, connections, or simple pleasures. Nurture it with activities that sustain your well-being and spread positivity.',
                      [
                        'Gratitude Exercise',
                        'Light Yoga Poses',
                        'Positive Affirmations',
                        'Mindful Walking',
                        'Guided Meditation',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatBotScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                    ),
                    child: const Text(
                      "Talk to ChatBot",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: const ExerciseList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
