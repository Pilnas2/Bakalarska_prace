// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/background_gradient.dart';
import '../controllers/language_mapper.dart';
import 'topic.dart';

class LevelLanguagePage extends StatelessWidget {
  final String language;

  const LevelLanguagePage({required this.language, super.key});

  Future<void> _saveSelectedLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLevelLanguage', level);
  }

  @override
  Widget build(BuildContext context) {
    final languageMapper = LanguageMapper(language);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(languageMapper.getTitle('select_level')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BackgroundGradient(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // A1 Level Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveSelectedLevel('A1');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TopicScreen(language_level: 'A1'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'A1',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // A2 Level Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveSelectedLevel('A2');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TopicScreen(language_level: 'A2'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'A2',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // B1 Level Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveSelectedLevel('B1');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TopicScreen(language_level: 'B1'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'B1',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // B2 Level Button
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveSelectedLevel('B2');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TopicScreen(language_level: 'B2'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'B2',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
