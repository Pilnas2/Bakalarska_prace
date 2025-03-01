import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'introduction.dart';
import '../background_gradient.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  Future<void> _navigateToIntroduction(
    BuildContext context,
    String language,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => IntroductionPage(language: language)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text(
                'Select Language',
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => _navigateToIntroduction(context, 'cs'),
                child: const Text('Česky'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToIntroduction(context, 'en'),
                child: const Text('English'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToIntroduction(context, 'ru'),
                child: const Text('Русский'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
