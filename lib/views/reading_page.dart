import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReadingPage extends StatefulWidget {
  final String topic;
  final String level;

  const ReadingPage({super.key, required this.topic, required this.level});

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  late DatabaseReference _database;
  String imageUrl = '';
  List<Map<String, String>> _phrases = [];
  List<Map<String, String>> _questions = [];
  List<String> _userAnswers = []; // Uloží odpovědi uživatele
  List<bool> _isAnswerCorrect = []; // Sledování správnosti odpovědí

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Reading',
    );
    fetchData();
  }

  Future<void> fetchData() async {
    final snapshot = await _database.get();
    if (!snapshot.exists) {
      return;
    }

    List<dynamic> data = snapshot.value as List<dynamic>;

    List<Map<String, String>> phrases =
        data.map((item) {
          final valueMap = item as Map<dynamic, dynamic>;
          return {
            "question": valueMap["question"]?.toString() ?? "Neznámá otázka",
            "answer": valueMap["answer"]?.toString() ?? "Neznámá odpověď",
          };
        }).toList();

    setState(() {
      _phrases = phrases;
    });

    final questionsSnapshot =
        await FirebaseDatabase.instance
            .ref('topics/${widget.level}/${widget.topic}/ReadingTest')
            .get();
    if (questionsSnapshot.exists) {
      List<dynamic> questionsData = questionsSnapshot.value as List<dynamic>;
      List<Map<String, String>> questions =
          questionsData.map((item) {
            final valueMap = item as Map<dynamic, dynamic>;
            return {
              "question": valueMap["question"]?.toString() ?? "Neznámá otázka",
              "answer": valueMap["answer"]?.toString() ?? "Neznámá odpověď",
              "hint": valueMap["hint"]?.toString() ?? "",
            };
          }).toList();

      setState(() {
        _questions = questions;
        _userAnswers = List.filled(_questions.length, "");
        _isAnswerCorrect = List.filled(_questions.length, false);
      });
    }

    final imageSnapshot =
        await FirebaseDatabase.instance.ref('images/${widget.topic}').get();
    if (imageSnapshot.exists) {
      setState(() {
        imageUrl = imageSnapshot.value.toString();
      });
    }
  }

  void _checkAnswer(int index, String value) {
    setState(() {
      _userAnswers[index] = value;
      _isAnswerCorrect[index] =
          value.trim().toLowerCase() ==
          _questions[index]["answer"]!.trim().toLowerCase();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAnswerCorrect[index] ? "Správná odpověď!" : "Špatná odpověď!",
        ),
        backgroundColor: _isAnswerCorrect[index] ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Čtení"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              widget.topic.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_phrases.isEmpty)
                      Center(child: CircularProgressIndicator())
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _phrases.length,
                        itemBuilder: (context, index) {
                          final phrase = _phrases[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        phrase["question"] ?? "Neznámá otázka",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        phrase["answer"] ?? "Neznámá odpověď",
                                        style: TextStyle(fontSize: 16),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                if (phrase["hint"] != null &&
                                    phrase["hint"]!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      phrase["hint"]!,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    Divider(),
                    Center(
                      child: Text(
                        "Odpovězte na otázky k textu:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        final questions = _questions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questions["question"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _userAnswers[index] =
                                              value; // Uložit odpověď
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: questions["hint"]!,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                _isAnswerCorrect[index]
                                                    ? Colors.green
                                                    : Colors.grey,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                _isAnswerCorrect[index]
                                                    ? Colors.green
                                                    : Colors.blue,
                                          ),
                                        ),
                                      ),
                                      controller: TextEditingController(
                                          text: _userAnswers[index],
                                        )
                                        ..selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset:
                                                    _userAnswers[index].length,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      _checkAnswer(index, _userAnswers[index]);
                                    },
                                    child: Text("Zkontrolovat"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
