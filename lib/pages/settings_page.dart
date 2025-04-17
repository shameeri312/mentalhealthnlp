import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/base_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentIndex: 3,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profile Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.deepOrange),
                title: const Text('Edit Profile'),
                onTap: () {
                  // Implement edit profile functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock, color: Colors.deepOrange),
                title: const Text('Change Password'),
                onTap: () {
                  // Implement change password functionality
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.notifications, color: Colors.deepOrange),
                title: const Text('Notifications'),
                onTap: () {
                  // Implement notifications settings
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
