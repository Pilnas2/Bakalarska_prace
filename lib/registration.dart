import 'package:flutter/material.dart';
import 'background_gradient.dart'; // Importujte BackgroundGradient
import 'language_mapper.dart'; // Importujte LanguageMapper

class RegistrationPage extends StatelessWidget {
  final String language;

  const RegistrationPage({required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    final languageMapper = LanguageMapper(language);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(languageMapper.getTitle('registration')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BackgroundGradient(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // First Name Field
                TextField(
                  decoration: InputDecoration(
                    labelText: languageMapper.getTitle('first_name'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Last Name Field
                TextField(
                  decoration: InputDecoration(
                    labelText: languageMapper.getTitle('last_name'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Username Field
                TextField(
                  decoration: InputDecoration(
                    labelText: languageMapper.getTitle('username'),
                    hintText: 'Jan123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Email Field
                TextField(
                  decoration: InputDecoration(
                    labelText: languageMapper.getTitle('email'),
                    hintText: 'jan@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: languageMapper.getTitle('password'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    // Handle registration action
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Text(
                      languageMapper.getTitle('register'),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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
