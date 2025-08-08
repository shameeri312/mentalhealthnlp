import 'package:flutter/material.dart';
import 'package:mental_health_nlp/utils/base_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Function to show dialog for updating backend URL
  Future<void> _showBackendUrlDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();
    final prefs = await SharedPreferences.getInstance();
    controller.text =
        prefs.getString('backend_ip') ?? 'http://192.168.100.35:5000';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Backend URL'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter backend URL',
            labelText: 'Backend URL',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newUrl = controller.text.trim();
              if (newUrl.isNotEmpty) {
                await prefs.setString('backend_ip', newUrl);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backend URL updated')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

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
                leading: const Icon(Icons.cloud, color: Colors.deepOrange),
                title: const Text('Backend URL'),
                onTap: () => _showBackendUrlDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
