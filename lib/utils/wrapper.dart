import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/pages/home_page.dart';
import 'package:mental_health_nlp/pages/login.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

// bottomNavigationBar: BottomNavigationBar(
//   selectedItemColor: Colors.blue[600], // Color of the selected label
//   unselectedItemColor: Colors.grey, // Color of the unselected labels

//   backgroundColor: Colors.white,
//   items: [
//     BottomNavigationBarItem(
//       backgroundColor: Colors.white,
//       icon: Icon(Icons.home, color: Colors.blue[600], size: 30),
//       label: 'Home',
//     ),
//     BottomNavigationBarItem(
//       backgroundColor: Colors.white,
//       icon: Icon(Icons.favorite, color: Colors.blue[600], size: 30),
//       label: 'Favourites',
//     ),
//     BottomNavigationBarItem(
//       backgroundColor: Colors.white,
//       icon: Icon(Icons.chat, color: Colors.blue[600], size: 30),
//       label: 'Messages',
//     ),
//     BottomNavigationBarItem(
//       backgroundColor: Colors.white,
//       icon: Icon(Icons.person, color: Colors.blue[600], size: 30),
//       label: 'Profile',
//     ),
//   ],
// ),

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        // Explicitly typing the stream
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
