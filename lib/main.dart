import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try-catch for Firebase initialization
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
    // Fallback or show error UI if needed
  }

  // Uncomment and configure the following for Supabase instead of Firebase
  /*
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
    anonKey: 'YOUR_ANON_KEY', // Replace with your Supabase anon key
  );
  print('Supabase initialized successfully');
  */

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Wrapper(), // Ensure Wrapper is stateless or adjust
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
        // Apply Montserrat font globally
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme.copyWith(
            headlineLarge: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
