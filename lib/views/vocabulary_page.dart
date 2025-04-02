import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VocabularyPage extends StatefulWidget {
  final String topic;
  final String level;

  const VocabularyPage({super.key, required this.topic, required this.level});

  @override
  _VocabularyPageState createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  late DatabaseReference _database;
  late PageController _pageController;
  String imageUrl = '';
  List<Map<String, String>> _phrases = [];

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Vocabulary',
    );
    fetchVocabulary();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Uvolnění PageControlleru
    super.dispose();
  }

  Future<void> fetchVocabulary() async {
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
            "hint": valueMap["hint"]?.toString() ?? "",
          };
        }).toList();

    final imageSnapshot =
        await FirebaseDatabase.instance.ref('images/${widget.topic}').get();
    if (imageSnapshot.exists) {
      setState(() {
        imageUrl = imageSnapshot.value.toString();
      });
    }

    setState(() {
      _phrases = phrases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Slovní zásoba"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    widget.topic.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  imageUrl.isNotEmpty
                      ? Image.network(imageUrl, width: 200, height: 100)
                      : CircularProgressIndicator(),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                controller: _pageController, // Použití PageControlleru
                scrollDirection: Axis.horizontal, // Nastaví swipování do stran
                children: [
                  // První stránka
                  _phrases.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _phrases.length,
                        itemBuilder: (context, index) {
                          var vocabulary = _phrases[index];
                          return Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    vocabulary["question"]!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    vocabulary["answer"]!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  // Druhá stránka - Test s inputem
                  _phrases.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _phrases.length,
                        itemBuilder: (context, index) {
                          var testPhrase = _phrases[index];
                          TextEditingController controller =
                              TextEditingController();

                          return Container(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment:
                                  index % 2 == 0
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                Text(
                                  testPhrase["question"]!,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width *
                                      0.6, // Nastavení šířky na 3/4 obrazovky
                                  child: TextField(
                                    textAlign:
                                        index % 2 == 0
                                            ? TextAlign.start
                                            : TextAlign.end,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: testPhrase["hint"] ?? "",
                                    ),
                                    onChanged: (value) {
                                      // Uložení odpovědi uživatele
                                      testPhrase["userAnswer"] = value;
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    String correctAnswer =
                                        testPhrase["answer"]!;
                                    String userAnswer =
                                        testPhrase["userAnswer"] ?? "";

                                    if (userAnswer.trim().toLowerCase() ==
                                        correctAnswer.trim().toLowerCase()) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Správná odpověď!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Špatná odpověď. Zkuste to znovu.",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Ověřit"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: SmoothPageIndicator(
                controller:
                    _pageController, // Připojení stejného PageControlleru
                count: 2, // Počet stránek v PageView
                effect: WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: Colors.deepOrangeAccent,
                  dotHeight: 9.0,
                  dotWidth: 9.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionTile extends StatelessWidget {
  final String emoji;
  final String question;
  final String hint;

  const QuestionTile({
    super.key,
    required this.emoji,
    required this.question,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
