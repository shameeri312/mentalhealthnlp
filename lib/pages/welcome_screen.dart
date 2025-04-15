// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Creates a container that fills the entire screen
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // Adds a gradient background similar to the image
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFF2A4A5A), // Dark teal at the top
              Color(0xFFB0D6E2), // Light teal at the bottom
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers content vertically
          children: [
            // Spacer to push content down a bit
            SizedBox(height: 50),

            // Title text: "Good to have you here!"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Good to have you here!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Subtitle text
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                'MindDoc is your companion on your path to emotional well-being. In addition daily exercises about moods and symptoms, psychological exercises and courses are available for you.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Placeholder for the illustration (replace with your image asset)
            Container(
              height: 200, // Adjust the height as needed
              child: Image.network(
                'https://via.placeholder.com/150', // Replace with your illustration asset
                fit: BoxFit.contain,
              ),
            ),

            // Spacer to separate illustration from the logo
            SizedBox(height: 20),

            // "by Schön Klinik" text with logo (placeholder for logo)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'by ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                Text(
                  'SCHÖN KLINIK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Spacer to separate logo from buttons
            SizedBox(height: 30),

            // "I already have an account" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity, // Makes the button full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Add navigation or logic for "I already have an account"
                    print('I already have an account pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                        0xFF2A2A2A), // Updated from 'primary' to 'backgroundColor'
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'I already have an account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

// Spacer between buttons
            SizedBox(height: 10),

// "Let's get started" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity, // Makes the button full-width
                child: ElevatedButton(
                  onPressed: () {
                    // Add navigation or logic for "Let's get started"
                    print('Let\'s get started pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(
                        0xFFF28C38), // Updated from 'primary' to 'backgroundColor'
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Let\'s get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ), // Spacer to separate buttons from the privacy policy text
            SizedBox(height: 20),

            // Privacy policy text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Check our privacy policy for data processing details.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
