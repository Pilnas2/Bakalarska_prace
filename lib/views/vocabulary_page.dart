import 'package:flutter/material.dart';

class VocabularyPage extends StatelessWidget {
  final List<Map<String, String>> vocabulary = [
    {"word": "Dům", "translation": "House"},
    {"word": "Kočka", "translation": "Cat"},
    {"word": "Strom", "translation": "Tree"},
    {"word": "Kniha", "translation": "Book"},
    {"word": "Auto", "translation": "Car"},
  ];

  VocabularyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Slovní zásoba")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Slovní zásoba",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: vocabulary.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        vocabulary[index]["word"]!,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        vocabulary[index]["translation"]!,
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
