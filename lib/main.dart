import 'package:bakalarska_prace_pilny/background_gradient.dart';
import 'package:bakalarska_prace_pilny/language_selection.dart';
import 'package:bakalarska_prace_pilny/registration.dart';
import 'package:flutter/material.dart';
import 'language_mapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Czech',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffFF65C2)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff8A4AF3),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const LanguageSelectionPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final String language;

  const LoginPage({required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    final languageMapper = LanguageMapper(language);

    return Scaffold(
      body: BackgroundGradient(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_learnCzech.png',
                      height: 200,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
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
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Handle login action
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    child: Text(
                      languageMapper.getTitle('login'),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Register Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RegistrationPage(language: language),
                      ),
                    );
                  },
                  child: Text(
                    languageMapper.getTitle('register'),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 211, 66, 153),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
