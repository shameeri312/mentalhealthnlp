import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/wrapper.dart';
import 'package:google_fonts/google_fonts.dart'; // Import google_fonts

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Wrapper(), // Add const if Wrapper is stateless
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF2176FF),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2176FF),
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 32.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),

        // Set Montserrat font globally
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
