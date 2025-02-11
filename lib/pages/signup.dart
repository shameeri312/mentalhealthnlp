import 'package:mental_health_nlp/pages/login.dart'; // Import the SignUp page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  signUp() async {
    try {
      if (password.text == confirmPassword.text) {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: email.text,
              password: password.text,
            );

        if (userCredential.user != null) {
          // Show success message (SnackBar or AlertDialog)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Sign Up Successful!")));

          // Redirect to login page after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(
              // Use pushReplacement to prevent going back
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          });
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already in use.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),

              Text(
                "Create an account to get access to mental health check app",
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft, // Keeps labels aligned left
                child: Text("Email", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 10),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  hintText: "Enter your email...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ), // Set blue color when focused
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft, // Keeps labels aligned left
                child: Text("Password", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ), // Set blue color when focused
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft, // Keeps labels aligned left
                child: Text("Confirm Password", style: TextStyle(fontSize: 18)),
              ),

              const SizedBox(height: 10),
              TextField(
                controller: confirmPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm your password...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ), // Set blue color when focused
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => signUp(),
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
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  // Navigate to the SignUp page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Colors.blue, // You can style it however you like
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
