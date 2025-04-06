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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
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
                      imageUrl.isNotEmpty
                          ? Image.network(imageUrl, width: 200, height: 200)
                          : CircularProgressIndicator(),
                    ],
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height / 2 -
                      MediaQuery.of(context).size.height * 0.1,
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      _phrases.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: _phrases.length,
                            itemBuilder: (context, index) {
                              var vocabulary = _phrases[index];
                              return Container(
                                padding: EdgeInsets.all(6.0),
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

                              bool isCorrect =
                                  testPhrase["isCorrect"] == "true";

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
                                      width: constraints.maxWidth / 2,
                                      child: TextField(
                                        textAlign:
                                            index % 2 == 0
                                                ? TextAlign.start
                                                : TextAlign.end,
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
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        String correctAnswer =
                                            testPhrase["answer"]!;
                                        String userAnswer =
                                            controller.text.trim();

                                        if (userAnswer.toLowerCase() ==
                                            correctAnswer
                                                .trim()
                                                .toLowerCase()) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Správná odpověď!"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          setState(() {
                                            testPhrase["userAnswer"] =
                                                testPhrase["answer"]!;
                                            testPhrase["isCorrect"] = "true";
                                          });
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
                                          setState(() {
                                            testPhrase["isCorrect"] = "false";
                                          });
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
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      0.03, // Dynamická výška SmoothPageIndicator
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      effect: WormEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.deepOrangeAccent,
                        dotHeight:
                            MediaQuery.of(context).size.height *
                            0.01, // Dynamická výška teček
                        dotWidth:
                            MediaQuery.of(context).size.height *
                            0.01, // Dynamická šířka teček
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
