// lib/utils/wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health_nlp/pages/home_page.dart'; // Screen for logged-in users
import 'package:mental_health_nlp/pages/welcome_screen.dart'; // Screen for non-authenticated users

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While waiting for the auth state to load, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If there's an error, show an error message (optional)
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error loading authentication state')),
          );
        }

        // If the user is logged in, show the HomePage
        if (snapshot.hasData) {
          return const HomePage();
        }

        // If the user is not logged in, show the WelcomeScreen
        return const WelcomeScreen();
      },
    );
  }
}
