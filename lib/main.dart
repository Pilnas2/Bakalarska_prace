// ignore_for_file: use_build_context_synchronously

import 'package:bakalarska_prace_pilny/controllers/user_session.dart';
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/views/edit_profile_page.dart';
import 'package:bakalarska_prace_pilny/views/grammar_lesson_page.dart';
import 'package:bakalarska_prace_pilny/views/introduction.dart';
//import 'package:bakalarska_prace_pilny/views/chatbot_page.dart';
import 'package:bakalarska_prace_pilny/views/language_selection.dart';
import 'package:bakalarska_prace_pilny/views/learning.dart';
import 'package:bakalarska_prace_pilny/views/level_language.dart';
import 'package:bakalarska_prace_pilny/views/listening_page.dart';
import 'package:bakalarska_prace_pilny/views/reading_page.dart';
import 'package:bakalarska_prace_pilny/views/registration.dart';
import 'package:bakalarska_prace_pilny/views/settings_page.dart';
import 'package:bakalarska_prace_pilny/views/topic.dart';
import 'package:bakalarska_prace_pilny/views/vocabulary_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'controllers/language_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  //pro zvolení jazyka stačí nastavit na null
  final selectedLanguage = prefs.getString('selectedLanguage');
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp(selectedLanguage: selectedLanguage));
}

class MyApp extends StatelessWidget {
  final String? selectedLanguage;

  const MyApp({super.key, this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Czech',
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffFF65C2)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff8A4AF3),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home:
          selectedLanguage == null
              ? const LanguageSelectionPage()
              : ReadingPage(topic: 'Seznamujeme se', level: 'A1'),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String language;

  const LoginPage({required this.language, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late LanguageMapper languageMapper;
  late String loggedInUsername;
  late String loggedInPassword;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    languageMapper = LanguageMapper(
      widget.language,
    ); // Initialize languageMapper here
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    try {
      final hashedPassword =
          sha256.convert(utf8.encode(passwordController.text)).toString();

      DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
      DatabaseEvent event =
          await usersRef
              .orderByChild('username')
              .equalTo(usernameController.text)
              .once();

      if (event.snapshot.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageMapper.getTitle('no_user_found'))),
        );
        return;
      }

      // Get the user data
      Map<dynamic, dynamic> userData =
          (event.snapshot.value as Map).values.first;

      // Check if the password matches
      if (userData['password'] != hashedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageMapper.getTitle('incorrect_password')),
          ),
        );
        return;
      } else {
        userSession.loggedInUsername = usernameController.text;
        userSession.loggedInPassword = passwordController.text;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LevelLanguagePage(language: widget.language),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${languageMapper.getTitle('error_occurred')}: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: usernameController,
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
                  controller: passwordController,
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
                  onPressed: login,
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
                        builder:
                            (_) => RegistrationPage(language: widget.language),
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
