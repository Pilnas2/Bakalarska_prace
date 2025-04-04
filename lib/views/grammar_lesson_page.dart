import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GrammarLessonPage extends StatefulWidget {
  final String topic;
  final String level;

  const GrammarLessonPage({
    super.key,
    required this.topic,
    required this.level,
  });

  @override
  _GrammarLessonPageState createState() => _GrammarLessonPageState();
}

class _GrammarLessonPageState extends State<GrammarLessonPage> {
  late DatabaseReference _database;
  late PageController _pageController;
  String imageUrl = '';
  List<Map<String, String>> _phrases = [];

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Grammar',
    );
    _fetchData();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Uvolnění PageControlleru
    super.dispose();
  }

  Future<void> _fetchData() async {
    // Fetch grammar data
    final snapshot = await _database.get();
    if (!snapshot.exists) {
      return;
    }
    // Pokud už data existují, neprováděj další dotaz
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

    setState(() {
      _phrases = phrases;
    });

    // Fetch image URL
    final imageSnapshot =
        await FirebaseDatabase.instance.ref('images/${widget.topic}').get();
    if (imageSnapshot.exists) {
      setState(() {
        imageUrl = imageSnapshot.value.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Gramatika"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                      ? Image.network(imageUrl, width: 200, height: 200)
                      : CircularProgressIndicator(),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: PageView(
                controller: _pageController, // Připojení PageControlleru
                scrollDirection: Axis.horizontal, // Nastaví swipování do stran
                children: [
                  // První stránka - Seznam otázek a odpovědí
                  _phrases.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _phrases.length,
                        itemBuilder: (context, index) {
                          var grammar = _phrases[index];
                          return Container(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    grammar["question"] ?? "Neznámá otázka",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    grammar["answer"] ?? "Neznámá odpověď",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
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
                              TextEditingController(
                                text: testPhrase["userAnswer"] ?? "",
                              );

                          bool isCorrect = testPhrase["isCorrect"] == "true";

                          return Container(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  testPhrase["question"] ?? "Neznámá otázka",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller,
                                  decoration: InputDecoration(
                                    hintText: testPhrase["hint"] ?? "",
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            isCorrect
                                                ? Colors.green
                                                : Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            isCorrect
                                                ? Colors.green
                                                : Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    testPhrase["userAnswer"] = value;
                                  },
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    String correctAnswer =
                                        testPhrase["answer"] ?? "";
                                    String userAnswer = controller.text.trim();

                                    if (userAnswer.toLowerCase() ==
                                        correctAnswer.trim().toLowerCase()) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Správná odpověď!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      setState(() {
                                        testPhrase["userAnswer"] =
                                            correctAnswer;
                                        testPhrase["isCorrect"] = "true";
                                      });
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Špatná odpověď. Zkuste to znovu.",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      setState(() {
                                        testPhrase["isCorrect"] = "false";
                                      });
                                    }
                                  },
                                  child: const Text("Ověřit"),
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
                controller: _pageController,
                count: 2,
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
