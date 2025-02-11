import 'package:flutter/material.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          _buildExerciseCard(
            'Speaking Skills',
            '15 Exercises',
            Icons.favorite,
            Colors.red[600]!,
            Colors.red[100]!,
          ),
          _buildExerciseCard(
            'Listening Practice',
            '10 Exercises',
            Icons.hearing,
            Colors.blue[600]!,
            Colors.blue[100]!,
          ),
          _buildExerciseCard(
            'Meditation',
            '8 Sessions',
            Icons.self_improvement,
            Colors.green[600]!,
            Colors.green[100]!,
          ),
          _buildExerciseCard(
            'Cognitive Training',
            '12 Exercises',
            Icons.psychology,
            Colors.purple[600]!,
            Colors.purple[100]!,
          ),
          _buildExerciseCard(
            'Stress Management',
            '9 Tips',
            Icons.spa,
            Colors.orange[600]!,
            Colors.orange[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
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
                padding: EdgeInsets.all(12),
                child: Center(child: Icon(icon, color: iconColor, size: 24)),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.more_horiz, color: Colors.black),
        ],
      ),
    );
  }
}
