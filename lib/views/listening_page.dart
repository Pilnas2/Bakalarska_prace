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

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Listening',
    );
    _fetchSentences();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Uvolnění PageControlleru
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
      appBar: AppBar(title: Text("Poslech")),
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
              height: MediaQuery.of(context).size.height / 2,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Testování odpovědí",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Vaše odpověď",
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Logika pro ověření odpovědi
                          },
                          child: Text("Odeslat"),
                        ),
                      ],
                    ),
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
