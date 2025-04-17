import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';
import 'package:mental_health_nlp/utils/base_scaffold.dart';

class AllExercisesPage extends StatelessWidget {
  const AllExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text(
                  'More Exercises',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    _buildExerciseCard(
                      context,
                      'Mindfulness',
                      'Calms your mind and reduces stress',
                      Colors.purple[600]!,
                      'assets/exercise1.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Relaxation',
                      'Eases tension and improves mood',
                      Colors.orange[600]!,
                      'assets/exercise2.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Self-Confidence',
                      'Boosts your self-esteem and positivity',
                      Colors.blue[600]!,
                      'assets/exercise3.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Gratitude Practice',
                      'Uplifts your mood with positive reflections',
                      Colors.indigo[600]!,
                      'assets/exercise4.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Yoga',
                      'Enhances flexibility and promotes inner peace',
                      Colors.green[600]!,
                      'assets/yoga.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Health',
                      'Encourages physical wellness and vitality',
                      Colors.red[600]!,
                      'assets/health.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Emotions',
                      'Helps you understand and manage your feelings',
                      Colors.teal[600]!,
                      'assets/emotions.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Thinking',
                      'Improves clarity and sharpens focus',
                      Colors.amber[600]!,
                      'assets/thinking.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Actions',
                      'Inspires purposeful and positive behaviors',
                      Colors.cyan[600]!,
                      'assets/actions.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Visualization',
                      'Boosts motivation through mental imagery',
                      Colors.lime[600]!,
                      'assets/visualization.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Journaling',
                      'Fosters self-reflection and emotional clarity',
                      Colors.brown[600]!,
                      'assets/journaling.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Affirmations',
                      'Builds confidence with positive self-talk',
                      Colors.grey[600]!,
                      'assets/affirmations.png',
                    ),
                    _buildExerciseCard(
                      context,
                      'Stretching',
                      'Relieves physical tension and boosts energy',
                      Colors.deepPurple[600]!,
                      'assets/stretching.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String description,
    Color bgColor,
    String pngPath,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatBotScreen(initialPrompt: "Suggest $title exercises for me"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        height: 150,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                pngPath,
                height: 142.5,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
