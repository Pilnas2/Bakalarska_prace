import 'package:bakalarska_prace_pilny/background_gradient.dart';
import 'package:bakalarska_prace_pilny/language_selection.dart';
import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const LanguageSelectionPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  decoration: InputDecoration(
                    labelText: 'Uživatelské jméno:',
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
                    labelText: 'Heslo:',
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8A4AF3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Text(
                      'Přihlásit se',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Register Link
                TextButton(
                  onPressed: () {
                    // Navigate to registration page
                  },
                  child: const Text(
                    'Registrovat se',
                    style: TextStyle(color: Color(0xffFF65C2), fontSize: 16),
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
