import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TestPage extends StatefulWidget {
  final String topic;
  final String level;

  const TestPage({required this.topic, super.key, required this.level});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late DatabaseReference _database;
  List<Map<String, dynamic>> _questions = [];
  List<String?> selectedOptions = []; // Uchovává vybrané možnosti pro otázky

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Test',
    );
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await _database.get();
    if (!snapshot.exists) {
      return;
    }

    List<dynamic> data = snapshot.value as List<dynamic>;
    List<Map<String, dynamic>> questions =
        data.map((item) {
          final valueMap = item as Map<dynamic, dynamic>;
          return {
            "question": valueMap["question"]?.toString() ?? "Neznámá otázka",
            "answer": valueMap["answer"]?.toString() ?? "Neznámá odpověď",
            "options": valueMap["options"] ?? [], // Zachování jako seznam
          };
        }).toList();

    setState(() {
      _questions = questions;
      selectedOptions = List<String?>.filled(
        questions.length,
        null,
      ); // Inicializace seznamu vybraných možností
    });
  }

  void _evaluateAnswers() {
    int correctAnswers = 0;
    List<int> incorrectIndexes = [];

    for (int i = 0; i < _questions.length; i++) {
      if (selectedOptions[i] == _questions[i]['answer']) {
        correctAnswers++;
      } else {
        incorrectIndexes.add(i); // Uložení indexu špatné odpovědi
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Výsledek testu"),
          content: Text(
            "Správné odpovědi: $correctAnswers z ${_questions.length}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showIncorrectAnswers(incorrectIndexes); // Zobrazení chyb
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showIncorrectAnswers(List<int> incorrectIndexes) {
    if (incorrectIndexes.isEmpty) {
      return; // Pokud nejsou žádné chyby, nic nezobrazuj
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chybné odpovědi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                incorrectIndexes.map((index) {
                  final question = _questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '${index + 1}. ${question['question']}\n'
                      'Správná odpověď: ${question['answer']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Zavřít"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body:
          _questions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        widget.topic,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final question = _questions[index];
                          final options = question['options'] as List<dynamic>;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${index + 1}. ${question['question']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                for (var option in options)
                                  RadioListTile<String>(
                                    title: Text(
                                      option.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    value: option.toString(),
                                    groupValue: selectedOptions[index],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOptions[index] = value;
                                      });
                                    },
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // Zarovnání doprava
                      children: [
                        ElevatedButton(
                          onPressed: _evaluateAnswers,
                          child: const Text("Vyhodnotit test"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
