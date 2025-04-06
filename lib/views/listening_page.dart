import 'package:bakalarska_prace_pilny/models/background_gradient.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ListeningPage extends StatefulWidget {
  final String topic;
  final String level;

  const ListeningPage({super.key, required this.topic, required this.level});

  @override
  _ListeningPageState createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  late DatabaseReference _database;
  late PageController _pageController;
  String imageUrl = '';
  final AudioPlayer audioPlayer = AudioPlayer();
  List<Map<String, String>> _sentences = [];
  bool isLoading = true;
  List<String> userAnswers = [];
  List<bool?> answerStates = [];

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Listening',
    );
    _fetchSentences(); // Načtení dat
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchSentences() async {
    final snapshot = await _database.get();
    if (!snapshot.exists) {
      return;
    }

    List<dynamic> data = snapshot.value as List<dynamic>;
    List<Map<String, String>> sentences =
        data.map((item) {
          final valueMap = item as Map<dynamic, dynamic>;
          return {
            "audio": valueMap["audio"]?.toString() ?? "Neznámá otázka",
            "text": valueMap["text"]?.toString() ?? "Neznámá odpověď",
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
      _sentences = sentences;
      userAnswers = List.filled(_sentences.length, ""); // Inicializace odpovědí
      answerStates = List.filled(
        _sentences.length,
        null,
      ); // Inicializace stavů odpovědí
      isLoading = false;
    });
  }

  Future<String> _getAudioUrl(String path) async {
    final ref = FirebaseStorage.instance.ref().child("audio/$path");
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Poslech"),
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
                controller: _pageController, // Použití PageControlleru
                scrollDirection: Axis.horizontal, // Nastaví swipování do stran
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sentences.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              _sentences[index]["text"]!,
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: () async {
                                final audioUrl = await _getAudioUrl(
                                  _sentences[index]['audio']!,
                                );
                                audioPlayer.play(UrlSource(audioUrl));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Nová stránka pro testování odpovědí
                  Center(
                    child: ListView.builder(
                      itemCount: _sentences.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () async {
                                        final audioUrl = await _getAudioUrl(
                                          _sentences[index]['audio']!,
                                        );
                                        audioPlayer.play(UrlSource(audioUrl));
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          userAnswers[index] =
                                              value; // Uložení odpovědi
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  answerStates[index] == null
                                                      ? Colors.grey
                                                      : (answerStates[index] ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red),
                                            ),
                                          ),
                                          labelText: "Vaše odpověď",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    _verifySingleAnswer(
                                      index,
                                    ); // Ověření konkrétní odpovědi
                                  },
                                  child: Text("Ověřit"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
      ),
    );
  }

  void _verifySingleAnswer(int index) {
    bool isCorrect =
        userAnswers[index].trim().toLowerCase() ==
        _sentences[index]['text']!.trim().toLowerCase();

    setState(() {
      answerStates[index] = isCorrect; // Aktualizace stavu odpovědi
    });

    // Zobrazení výsledku pomocí Snackbar nad klávesnicí
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating, // Nastavení plovoucího Snackbaru
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Nad klávesnicí
        ),
        content: Text(
          isCorrect ? "Odpověď je správná!" : "Odpověď je špatná. ",
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
