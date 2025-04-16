import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_screen.dart'; // Import the WelcomeScreen

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
  bool? _isFirstLaunch; // Make it nullable to indicate loading state

  @override
  void initState() {
    super.initState();
    // Don't call _checkFirstLaunch here; we'll handle it in the FutureBuilder
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (isFirstLaunch) {
      _showDialog = true;
      await prefs.setBool('first_launch', false);
      return true; // Show WelcomeScreen on first launch
    }
    return false; // Skip WelcomeScreen on subsequent launches
  }

  Future<void> _setInitialIp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    TextEditingController ipController = TextEditingController(
        text: prefs.getString('backend_ip') ?? 'http://192.168.100.35:5000');
    return showDialog(
      context: context,
      barrierDismissible: false,
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
    return FutureBuilder<bool>(
      future: _checkFirstLaunch(),
      builder: (context, snapshot) {
        // While waiting for _checkFirstLaunch to complete, show a loading indicator
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Once _checkFirstLaunch completes, snapshot.data will be true or false
        _isFirstLaunch = snapshot.data!;

        // Show the IP dialog after the WelcomeScreen or Wrapper is displayed
        if (_showDialog) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setInitialIp(context);
          });
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // Use Navigator to manage routes and handle logout redirection
          home: Navigator(
            onGenerateRoute: (settings) {
              Widget page;
              if (_isFirstLaunch!) {
                page = WelcomeScreen();
              } else {
                page = const Wrapper();
              }
              return MaterialPageRoute(builder: (_) => page);
            },
          ),
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            primaryColor: const Color(0xFF2176FF),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2176FF),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
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
      },
    );
  }
}
