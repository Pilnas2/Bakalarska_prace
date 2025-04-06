// ignore_for_file: use_build_context_synchronously

import 'package:bakalarska_prace_pilny/controllers/user_session.dart';
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/models/custom_bottom_nav_bar.dart';
import 'package:bakalarska_prace_pilny/views/chatbot_page.dart';
import 'package:bakalarska_prace_pilny/views/learning.dart';
import 'package:bakalarska_prace_pilny/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final String topic;

  const EditProfilePage({super.key, required this.topic});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSelectedLevel();
  }

  Future<void> _loadSelectedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLevel = prefs.getString(
        'selectedLevelLanguage',
      ); // Načtení hodnoty
    });
  }

  Future<void> _loadUserData() async {
    try {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref('users');

      DatabaseEvent event =
          await databaseRef
              .orderByChild('username')
              .equalTo(userSession.loggedInUsername)
              .once();

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> users =
            event.snapshot.value as Map<dynamic, dynamic>;

        // Předpokládáme, že uživatelské jméno je unikátní, takže vezmeme první záznam
        Map<dynamic, dynamic> userData = users.values.first;

        setState(() {
          _firstNameController.text = userData['first_name'] ?? '';
          _lastNameController.text = userData['last_name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _usernameController.text = userData['username'] ?? '';
          _passwordController.text = userSession.loggedInPassword;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chyba při načítání dat uživatele: $e')),
      );
    }
  }

  Future<void> controlDb() async {
    if (_formKey.currentState!.validate()) {
      try {
        DatabaseReference databaseRef = FirebaseDatabase.instance.ref('users');

        // Najdi aktuálního uživatele podle přihlášeného uživatelského jména
        DatabaseEvent event =
            await databaseRef
                .orderByChild('username')
                .equalTo(userSession.loggedInUsername)
                .once();

        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> users =
              event.snapshot.value as Map<dynamic, dynamic>;

          // Předpokládáme, že uživatelské jméno je unikátní, získáme první klíč
          String userKey = users.keys.first;

          // Zkontroluj, zda nové uživatelské jméno již existuje
          if (_usernameController.text != userSession.loggedInUsername) {
            DatabaseEvent usernameCheckEvent =
                await databaseRef
                    .orderByChild('username')
                    .equalTo(_usernameController.text)
                    .once();

            if (usernameCheckEvent.snapshot.value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Uživatelské jméno již existuje.')),
              );
              return;
            }
          }

          // Hashování hesla pomocí SHA-256
          String hashedPassword =
              sha256.convert(utf8.encode(_passwordController.text)).toString();

          // Aktualizuj data uživatele
          await databaseRef.child(userKey).update({
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'email': _emailController.text,
            'username': _usernameController.text,
            'password': hashedPassword, // Uložíme zahashované heslo
          });

          // Aktualizuj session pouze po úspěšném uložení
          userSession.loggedInUsername = _usernameController.text;
          userSession.loggedInPassword = _passwordController.text;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Profil úspěšně editován!')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Uživatel nebyl nalezen.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chyba při aktualizaci dat: $e')),
        );
      }
    }
  }

  int _selectedIndex = 2;

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Přesměrování na konkrétní stránky
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
        title: Text('Upravit profil'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (BuildContext scaffoldContext) {
              return Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'Jméno'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím zadejte vaše jméno';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Příjmení'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím zadejte vaše přijmení';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím zadejte váš email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Prosím zadejte platnou emailovou adresu';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Uživatelské jméno',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím zadejte vaše uživatelské jméno';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Heslo',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Prosím zadejte vaše heslo';
                        }
                        if (value.length < 6) {
                          return 'Heslo musí být alespoň 6 znaků dlouhé';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            DatabaseReference databaseRef = FirebaseDatabase
                                .instance
                                .ref('users');

                            // Najdi aktuálního uživatele podle přihlášeného uživatelského jména
                            DatabaseEvent event =
                                await databaseRef
                                    .orderByChild('username')
                                    .equalTo(userSession.loggedInUsername)
                                    .once();

                            if (event.snapshot.value != null) {
                              Map<dynamic, dynamic> users =
                                  event.snapshot.value as Map<dynamic, dynamic>;

                              // Předpokládáme, že uživatelské jméno je unikátní, získáme první klíč
                              String userKey = users.keys.first;

                              // Zkontroluj, zda nové uživatelské jméno již existuje
                              if (_usernameController.text !=
                                  userSession.loggedInUsername) {
                                DatabaseEvent usernameCheckEvent =
                                    await databaseRef
                                        .orderByChild('username')
                                        .equalTo(_usernameController.text)
                                        .once();

                                if (usernameCheckEvent.snapshot.value != null) {
                                  ScaffoldMessenger.of(
                                    scaffoldContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Uživatelské jméno již existuje.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                              }

                              // Hashování hesla pomocí SHA-256
                              String hashedPassword =
                                  sha256
                                      .convert(
                                        utf8.encode(_passwordController.text),
                                      )
                                      .toString();

                              // Aktualizuj data uživatele
                              await databaseRef.child(userKey).update({
                                'first_name': _firstNameController.text,
                                'last_name': _lastNameController.text,
                                'email': _emailController.text,
                                'username': _usernameController.text,
                                'password':
                                    hashedPassword, // Uložíme zahashované heslo
                              });

                              // Aktualizuj session pouze po úspěšném uložení
                              userSession.loggedInUsername =
                                  _usernameController.text;
                              userSession.loggedInPassword =
                                  _passwordController.text;

                              ScaffoldMessenger.of(
                                scaffoldContext,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text('Profil úspěšně editován!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(
                                scaffoldContext,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text('Uživatel nebyl nalezen.'),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                              SnackBar(
                                content: Text('Chyba při aktualizaci dat: $e'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text('Uložit změny'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
