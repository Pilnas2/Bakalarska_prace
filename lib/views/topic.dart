// ignore_for_file: non_constant_identifier_names
import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/views/learning.dart';
import 'package:flutter/material.dart';

class TopicScreen extends StatelessWidget {
  final List<String> topics = [
    "Rodina",
    "Pozdravy a představování",
    "Barvy",
    "Povolání",
    "Jídlo",
    "Nakupování",
  ];
  final String language_level;

  TopicScreen({super.key, required this.language_level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Téma"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: BackgroundGradient(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                language_level,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...topics.map(
                (topic) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LearningMenuPage(topic: topic),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(254, 100, 195, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      topic,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
