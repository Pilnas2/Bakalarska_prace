// ignore_for_file: use_build_context_synchronously

import 'package:bakalarska_prace_pilny/main.dart';
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/models/custom_bottom_nav_bar.dart';
import 'package:bakalarska_prace_pilny/views/chatbot_page.dart';
import 'package:bakalarska_prace_pilny/views/edit_profile_page.dart';
import 'package:bakalarska_prace_pilny/views/learning.dart';
import 'package:bakalarska_prace_pilny/views/topic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  final String topic;

  const SettingsPage({super.key, required this.topic});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedLevel;
  String? _selectedLanguage;
  String? _appVersion;

  final Map<String, String> languageMap = {
    'en': 'English',
    'cz': 'Česky',
    'ru': 'Русский',
  };

  @override
  void initState() {
    super.initState();
    _loadSelectedLevel();
    _loadSelectedLanguage();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _loadSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLevel = prefs.getString(
        'selectedLevelLanguage',
      ); // Načtení hodnoty
    });
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString(
        'selectedLanguage',
      ); // Načtení hodnoty
    });
  }

  void saveSettings() {
    // Implement save logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Změna úspěšně uložena!')));
  }

  void logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Odhlásit se'),
            content: Text('Určitě se chcete odhlásit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Zrušit'),
              ),
              TextButton(
                onPressed: () async {
                  // Zavření dialogu
                  Navigator.of(context).pop();

                  // Přesměrování na přihlašovací stránku
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => LoginPage(language: _selectedLanguage!),
                    ),
                  );
                },
                child: Text('Odhlásit se'),
              ),
            ],
          ),
    );
  }

  int _selectedIndex = 3;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  LearningMenuPage(topic: widget.topic, level: _selectedLevel!),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatbotPage(topic: widget.topic),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(topic: widget.topic),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(topic: widget.topic),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Nastavení'),
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
                'Vyberte jazyk:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value:
                    _selectedLanguage != null
                        ? languageMap[_selectedLanguage] // Převod kódu na text
                        : null,
                items:
                    languageMap.values
                        .map(
                          (language) => DropdownMenuItem(
                            value: language,
                            child: Text(language),
                          ),
                        )
                        .toList(),
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    _selectedLanguage =
                        languageMap.entries
                            .firstWhere((entry) => entry.value == value)
                            .key; // Uložení kódu jazyka
                  });
                  await prefs.setString(
                    'selectedLanguage',
                    _selectedLanguage!,
                  ); // Uložení do SharedPreferences
                  saveSettings(); // Zavolání metody saveSettings
                },
                underline: SizedBox(),
              ),
              SizedBox(height: 20),

              // Language Level Selection
              Text(
                'Vyberte úroveň jazyka:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedLevel,
                items:
                    ['A1', 'A2', 'B1', 'B2']
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                onChanged: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(
                    'selectedLevelLanguage',
                    value!,
                  ); // Uložení do SharedPreferences
                  setState(() {
                    _selectedLevel = value;
                    saveSettings();
                  });
                  Navigator.of(context).pop();

                  // Přesměrování na přihlašovací stránku
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              TopicScreen(language_level: _selectedLevel!),
                    ),
                  );
                },
                underline: SizedBox(),
              ),
              SizedBox(height: 20),

              // Save Button
              Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Odhlásit se'),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  '$_appVersion',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 59, 59, 59),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
