import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:bakalarska_prace_pilny/models/custom_bottom_nav_bar.dart';
import 'package:bakalarska_prace_pilny/views/chatbot_page.dart';
import 'package:bakalarska_prace_pilny/views/edit_profile_page.dart';
import 'package:bakalarska_prace_pilny/views/settings_page.dart';
import 'package:bakalarska_prace_pilny/views/test_page.dart';
import 'package:flutter/material.dart';
import 'grammar_lesson_page.dart';
import 'vocabulary_page.dart';
import 'listening_page.dart';
import 'reading_page.dart';

class LearningMenuPage extends StatefulWidget {
  final String topic;
  final String level;

  const LearningMenuPage({super.key, required this.topic, required this.level});

  @override
  _LearningMenuPageState createState() => _LearningMenuPageState();
}

class _LearningMenuPageState extends State<LearningMenuPage> {
  int _selectedIndex = 0;

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
                  LearningMenuPage(topic: widget.topic, level: widget.level),
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
        title: Text(widget.topic),
        centerTitle: true,
        flexibleSpace: BackgroundGradient(child: Container()),
      ),
      body: BackgroundGradient(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildTile(context, 'Gramatika', Icons.menu_book, Colors.blue),
              _buildTile(
                context,
                'Slovní zásoba',
                Icons.translate,
                Colors.green,
              ),
              _buildTile(context, 'Poslech', Icons.hearing, Colors.orange),
              _buildTile(
                context,
                'Čtení',
                Icons.chrome_reader_mode,
                Colors.red,
              ),
              _buildTile(
                context,
                'Test',
                Icons.fact_check_rounded,
                Colors.purple,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        if (title == 'Gramatika') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      GrammarLessonPage(topic: widget.topic, level: 'A1'),
            ),
          );
        } else if (title == 'Slovní zásoba') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      VocabularyPage(topic: widget.topic, level: widget.level),
            ),
          );
        } else if (title == 'Poslech') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ListeningPage(topic: widget.topic, level: widget.level),
            ),
          );
        } else if (title == 'Čtení') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ReadingPage(topic: widget.topic, level: widget.level),
            ),
          );
        } else if (title == 'Test') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      TestPage(topic: widget.topic, level: widget.level),
            ),
          );
        }
      },
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
