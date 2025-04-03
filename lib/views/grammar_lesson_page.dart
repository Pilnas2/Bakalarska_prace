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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Grammar',
    );
    _pageController = PageController();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // Fetch grammar data
    final snapshot = await _database.get();
    if (snapshot.exists) {
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
    }

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
      appBar: AppBar(
        title: Text("Gramatika"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (imageUrl.isNotEmpty) ...[
              Text(
                widget.topic.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Image.network(imageUrl, width: 200, height: 200),
              ),
            ],
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: PageView(
                controller: _pageController, // Použití PageControlleru
                scrollDirection: Axis.horizontal, // Nastaví swipování do stran
                children: [
                  Expanded(
                    child:
                        _phrases.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                              itemCount: _phrases.length,
                              itemBuilder: (context, index) {
                                var grammar = _phrases[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              grammar["question"] ??
                                                  "Neznámá otázka",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              grammar["answer"] ??
                                                  "Neznámá odpověď",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.grey),
                                    ],
                                  ),
                                );
                              },
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
          ],
        ),
      ),
    );
  }
}
