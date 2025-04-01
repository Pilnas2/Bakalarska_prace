import 'package:bakalarska_prace_pilny/controllers/user_session.dart';
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert'; // Pro utf8 a base64
import 'package:crypto/crypto.dart'; // Pro hashování

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

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

  // State for password visibility
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                          return 'Please enter your first name';
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
                          return 'Please enter your last name';
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
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
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
                          return 'Please enter your username';
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
                          return 'Please enter your password';
                        }
                        if (value.length < 1) {
                          return 'Password must be at least 6 characters long';
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
