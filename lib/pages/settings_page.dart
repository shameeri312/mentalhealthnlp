import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService().deleteAccount();
            Navigator.pop(context);
          },
          child: Text("Delete My Data"),
        ),
      ),
    );
  }
}
