import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildExerciseCard(
          context,
          'Understanding Mental Disorders',
          '11 courses',
          Icons.visibility,
          Colors.teal[600]!,
          Colors.teal[100]!,
        ),
        _buildExerciseCard(
          context,
          'Mindfulness',
          '1 course',
          Icons.self_improvement,
          Colors.purple[600]!,
          Colors.purple[100]!,
        ),
        _buildExerciseCard(
          context,
          'Relaxation',
          '2 courses',
          Icons.local_dining,
          Colors.orange[600]!,
          Colors.orange[100]!,
        ),
        _buildExerciseCard(
          context,
          'Self-Confidence',
          '1 course | 8 exercises',
          Icons.person,
          Colors.blue[600]!,
          Colors.blue[100]!,
        ),
        _buildExerciseCard(
          context,
          'Thinking',
          '3 courses | 5 exercises',
          Icons.lightbulb_outline,
          Colors.teal[600]!,
          Colors.teal[100]!,
        ),
        _buildExerciseCard(
          context,
          'Emotions',
          '2 courses',
          Icons.favorite,
          Colors.blue[600]!,
          Colors.blue[100]!,
        ),
        _buildExerciseCard(
          context,
          'Take Action',
          '3 courses | 1 exercise',
          Icons.play_arrow,
          Colors.orange[600]!,
          Colors.orange[100]!,
        ),
        _buildExerciseCard(
          context,
          'Sleep',
          '2 courses | 3 exercises',
          Icons.hotel,
          Colors.indigo[600]!,
          Colors.indigo[100]!,
        ),
        _buildExerciseCard(
          context,
          'Taking Care of Your Body',
          '2 courses',
          Icons.fitness_center,
          Colors.teal[600]!,
          Colors.teal[100]!,
        ),
        _buildExerciseCard(
          context,
          'Relationships',
          '2 courses | 2 exercises',
          Icons.people,
          Colors.blue[600]!,
          Colors.blue[100]!,
        ),
      ],
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
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
        height: 150, // Increased height to 140
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/illustration.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
