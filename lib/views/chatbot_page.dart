import 'package:bakalarska_prace_pilny/controllers/Message.dart';
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/models/custom_bottom_nav_bar.dart';
import 'package:bakalarska_prace_pilny/views/edit_profile_page.dart';
import 'package:bakalarska_prace_pilny/views/learning.dart';
import 'package:bakalarska_prace_pilny/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatbotPage extends StatefulWidget {
  final String topic; // Add the 'topic' property

  const ChatbotPage({super.key, required this.topic});

  @override
  // ignore: library_private_types_in_public_api
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final String apiKey = dotenv.env['API_KEY_AI']!;
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
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

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add(Message(message, true));
      _scrollToBottom();
    });

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "Jsi chatbot, který trénuje mluvit česky.",
          },
          {"role": "user", "content": message},
        ],
        "max_tokens": 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final reply = data['choices'][0]['message']['content'];

      setState(() {
        _messages.add(Message(reply, false));
      });
    } else {
      setState(() {
        _messages.add(Message("Chyba při získávání odpovědi", false));
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  int _selectedIndex = 1;

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
        ), // Pass the topic from ChatbotPage
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
        title: const Text('Komunikační asistent'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BackgroundGradient(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message.isUserMessage;

                  return Align(
                    alignment:
                        isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                            color:
                                isUserMessage
                                    ? Color(0xff8A4AF3)
                                    : Color(0xffFF65C2),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Zadejte zprávu',
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ), // Zaoblené rohy
                          borderSide: BorderSide.none, // Skrytí okrajů
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _controller.text;
                      _controller.clear();
                      _sendMessage(message);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}
