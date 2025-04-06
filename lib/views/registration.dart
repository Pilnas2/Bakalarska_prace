// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bakalarska_prace_pilny/controllers/user_session.dart';
import 'package:bakalarska_prace_pilny/views/level_language.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../models/background_gradient.dart';
import '../controllers/language_mapper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  final String language;

  const RegistrationPage({required this.language, super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void addUser() async {
    if (_formKey.currentState!.validate()) {
      final databaseReference = FirebaseDatabase.instance.ref();

      // Zkontrolujte, zda uživatelské jméno již existuje
      final snapshot =
          await databaseReference
              .child('users')
              .orderByChild('username')
              .equalTo(usernameController.text)
              .get();

      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Uživatelské jméno již existuje.')),
        );
        return;
      }

      // Hash the password using SHA-256
      var bytes = utf8.encode(passwordController.text);
      var hashedPassword = sha256.convert(bytes).toString();

      databaseReference
          .child('users')
          .push()
          .set({
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
            'username': usernameController.text,
            'email': emailController.text,
            'password': hashedPassword,
          })
          .then((value) async {
            userSession.loggedInUsername = usernameController.text;
            userSession.loggedInPassword = passwordController.text;

            final prefs = await SharedPreferences.getInstance();

            final selectedLanguage = prefs.getString('selectedLanguage');

            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          LevelLanguagePage(language: selectedLanguage!),
                ),
              );
            }
          })
          .catchError((error) {
            // Handle error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Chyba při registraci uživatele: $error')),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageMapper = LanguageMapper(widget.language);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text(languageMapper.getTitle('registration')),
        centerTitle: true,
        flexibleSpace: BackgroundGradient(child: Container()),
        elevation: 0,
      ),
      body: BackgroundGradient(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // First Name Field
                  TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('first_name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle(
                          'please_enter_first_name',
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Last Name Field
                  TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('last_name'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle(
                          'please_enter_last_name',
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Username Field
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('username'),
                      hintText: 'Jan123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle('please_enter_username');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('email'),
                      hintText: 'jan@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle('please_enter_email');
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return languageMapper.getTitle('invalid_email');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle('please_enter_password');
                      }
                      if (value.length < 6) {
                        return languageMapper.getTitle('password_too_short');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password Field
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: languageMapper.getTitle('confirm_password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return languageMapper.getTitle(
                          'please_confirm_password',
                        );
                      }
                      if (value != passwordController.text) {
                        return languageMapper.getTitle(
                          'passwords_do_not_match',
                        );
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  // Register Button
                  ElevatedButton(
                    onPressed: () {
                      addUser();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      child: Text(
                        languageMapper.getTitle('register'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
