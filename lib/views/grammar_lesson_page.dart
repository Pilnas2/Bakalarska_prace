import 'package:flutter/material.dart';

class GrammarLessonPage extends StatelessWidget {
  final String lessonTitle = "Shoda podmětu s přísudkem";
  final String lessonDescription =
      "V češtině se přísudek shoduje s podmětem v osobě, čísle a rodě. "
      "Například pokud je podmět mužského rodu v množném čísle, přísudek musí mít koncovku -i.";
  final List<String> examples = [
    "Chlapci běželi do školy.",
    "Dívky zpívaly na koncertě.",
    "Děti si hrály na hřišti.",
  ];

  GrammarLessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lekce gramatiky")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lessonTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(lessonDescription, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              "Příklady:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...examples.map(
              (example) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text("• $example", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
