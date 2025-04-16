import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';
import 'package:mental_health_nlp/pages/settings_page.dart';
import 'package:mental_health_nlp/utils/emotion_face.dart';
import 'package:mental_health_nlp/utils/exercises_list.dart';
import 'welcome_screen.dart'; // Import the WelcomeScreen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0; // Track the current tab index

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
      (route) => false,
    );
  }

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
    'Visualization Technique',
    'Body Scan Meditation',
    'Nature Walk',
  ];

  // Updated method to show mood information and suggested exercises
  void showMoodDialog(
      String mood, String description, List<String> suggestedExercises) {
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
      List<String> suggestedExercises) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "MindEase",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Divider(
            color: Colors.deepOrange,
            thickness: 2.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Make the entire content scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section (unchanged)

              const SizedBox(height: 20),

              // Updated "How do you feel?" Section
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: showExerciseDialog,
                      child: const Text(
                        'more',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Emotion Icons Row
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

              // Chatbot Button (unchanged)
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
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
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

              const SizedBox(height: 25),

              // Exercises Section with Limited Height
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          onTap: showExerciseDialog,
                          child: const Text(
                            'more',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 500,
                      child: const ExerciseList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.deepOrange, width: 2.0),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }

  // _onItemTapped method (unchanged)
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        showExerciseDialog();
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatBotScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 4:
        signout();
        break;
    }
  }

  // showExerciseDialog method (unchanged)
  void showExerciseDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Available Exercises"),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatBotScreen(
                        initialPrompt: "Suggest $exercise exercises for me",
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}. $exercise',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            const Text(
                              'Click to get exercises',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
