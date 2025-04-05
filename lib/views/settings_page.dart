import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Česky';
  String _selectedLevel = 'Beginner';

  void _saveSettings() {
    // Implement save logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Settings saved successfully!')));
  }

  void _logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Add logout functionality
                  Navigator.of(context).pop();
                  // Navigate to login screen or perform logout
                },
                child: Text('Logout'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Selection
              Text(
                'Select Language:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedLanguage,
                items:
                    ['English', 'Česky', 'Русский']
                        .map(
                          (language) => DropdownMenuItem(
                            value: language,
                            child: Text(language),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Language Level Selection
              Text(
                'Select Language Level:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedLevel,
                items:
                    ['Beginner', 'Intermediate', 'Advanced']
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BackgroundGradient(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _logout,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50), // Full width button
            ),
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}
