import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showDialog = false;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (isFirstLaunch) {
      _showDialog = true;
      prefs.setBool('first_launch', false);
      setState(() {});
    }
  }

  Future<void> _setInitialIp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    TextEditingController ipController = TextEditingController(
        text: prefs.getString('backend_ip') ?? 'http://192.168.100.35:5000');
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Backend IP'),
          content: TextField(
            controller: ipController,
            decoration: const InputDecoration(
                hintText: 'Enter IP (e.g., http://192.168.100.35:5000)'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (ipController.text.isNotEmpty) {
                  await prefs.setString('backend_ip', ipController.text);
                  setState(() {
                    _showDialog = false;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _setInitialIp(context);
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: const Color(0xFF2176FF),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2176FF),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
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
