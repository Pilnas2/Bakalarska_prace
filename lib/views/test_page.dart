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
                  ],
                ),
              ),
    );
  }
}
