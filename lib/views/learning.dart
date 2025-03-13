import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:flutter/material.dart';
import 'grammar_lesson_page.dart';
import 'vocabulary_page.dart';
import 'listening_page.dart';
import 'reading_page.dart';

class LearningMenuPage extends StatelessWidget {
  final String topic;

  const LearningMenuPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(topic),
        centerTitle: true,
        backgroundColor: Colors.transparent,
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
            MaterialPageRoute(builder: (context) => GrammarLessonPage()),
          );
        } else if (title == 'Slovní zásoba') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VocabularyPage()),
          );
        } else if (title == 'Poslech') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListeningPage()),
          );
        } else if (title == 'Čtení') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReadingPage()),
          );
        } else {
          // Přidat navigaci na konkrétní stránku pro ostatní dlaždice
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
