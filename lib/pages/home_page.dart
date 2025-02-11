import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/emotion_face.dart';
import 'package:mental_health_nlp/utils/exercises_list.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signout()),
        backgroundColor: const Color(0xFF2176ff),
        foregroundColor: Colors.white,
        child: const Icon(Icons.logout_rounded),
      ),
      backgroundColor: Color(0xFF2176ff),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.10), // Use const
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // Consistent padding
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white), // Use const
                    const SizedBox(width: 10), // Increased spacing
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search...", // Add ellipsis for long text
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(
                              0.7,
                            ), // Slightly transparent hint
                          ),
                          border: InputBorder.none, // No border
                          contentPadding:
                              EdgeInsets.zero, // Remove default padding
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ), // Use const
                        cursorColor: Colors.white, // Set cursor color
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // "How do you feel?" Section
            Padding(
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
                  Column(
                    children: [
                      EmotionFace(EmotionIcon: '😄'),
                      SizedBox(height: 8),
                      Text(
                        'Fine',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      EmotionFace(EmotionIcon: '😟'),
                      SizedBox(height: 8),
                      Text(
                        'Bad',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      EmotionFace(EmotionIcon: '😊'),
                      SizedBox(height: 8),
                      Text(
                        'Well',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      EmotionFace(EmotionIcon: '🥳'),
                      SizedBox(height: 8),
                      Text(
                        'Excellent',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            // Expanded Bottom Section with Exercises
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: EdgeInsets.all(25),
                child: Column(
                  children: [
                    // Exercise heading
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Icon(Icons.more_horiz, color: Colors.black),
                      ],
                    ),

                    SizedBox(height: 20),

                    // List view of exercises
                    const ExerciseList(),
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
