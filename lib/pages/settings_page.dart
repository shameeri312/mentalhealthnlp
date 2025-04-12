import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _ipController = TextEditingController();
  String? _currentIp;

  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  Future<void> _loadIp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIp =
          prefs.getString('backend_ip') ?? 'http://192.168.100.35:5000';
      _ipController.text = _currentIp!;
    });
  }

  Future<void> _saveIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backend_ip', _ipController.text);
    setState(() {
      _currentIp = _ipController.text;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('IP address saved: ${_ipController.text}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF2176FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backend IP Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                hintText: 'Enter backend IP (e.g., http://192.168.100.35:5000)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIp,
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xFF2176FF)),
              child: Text('Save IP', style: TextStyle(color: Colors.white)),
            ),
            if (_currentIp != null) ...[
              SizedBox(height: 20),
              Text('Current IP: $_currentIp', style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
