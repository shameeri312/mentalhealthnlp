import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/chatbot_screen.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildExerciseCard(
            context, // Pass context
            'Speaking Skills',
            'Click to get exercises',
            Icons.favorite,
            Colors.red[600]!,
            Colors.red[100]!,
          ),
          _buildExerciseCard(
            context,
            'Listening Practice',
            'Click to get exercises',
            Icons.hearing,
            Colors.blue[600]!,
            Colors.blue[100]!,
          ),
          _buildExerciseCard(
            context,
            'Meditation',
            'Click to get exercises',
            Icons.self_improvement,
            Colors.green[600]!,
            Colors.green[100]!,
          ),
          _buildExerciseCard(
            context,
            'Cognitive Training',
            'Click to get exercises',
            Icons.psychology,
            Colors.purple[600]!,
            Colors.purple[100]!,
          ),
          _buildExerciseCard(
            context,
            'Stress Management',
            'Click to get exercises',
            Icons.spa,
            Colors.orange[600]!,
            Colors.orange[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, // Add context parameter
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to ChatBotScreen with initial prompt
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatBotScreen(initialPrompt: "Suggest $title exercises for me"),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Center(child: Icon(icon, color: iconColor, size: 24)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to ChatBotScreen with initial prompt
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBotScreen(
                        initialPrompt: "Suggest $title exercises for me"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
