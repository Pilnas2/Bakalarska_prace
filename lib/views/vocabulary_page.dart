import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VocabularyPage extends StatefulWidget {
  final String topic;
  final String level;

  const VocabularyPage({super.key, required this.topic, required this.level});

  @override
  _VocabularyPageState createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  late DatabaseReference _database;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref(
      'topics/${widget.level}/${widget.topic}/Vocabulary',
    );
    fetchVocabulary();
  }

  Future<void> fetchVocabulary() async {
    final snapshot = await _database.get();
    if (!snapshot.exists) {
      return;
    }

    List<dynamic> data = snapshot.value as List<dynamic>;
    List<Map<String, String>> phrases =
        data.map((entry) {
          return {
            "question": entry["question"]?.toString() ?? "Neznámá otázka",
            "answer": entry["answer"]?.toString() ?? "Neznámá odpověď",
          };
        }).toList();

    final imageSnapshot =
        await FirebaseDatabase.instance.ref('images/Seznamujeme se').get();
    if (imageSnapshot.exists) {
      setState(() {
        imageUrl = imageSnapshot.value.toString();
      });
    }

    setState(() {
      _phrases = phrases;
    });
  }

  List<Map<String, String>> _phrases = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(height: 10),
            Expanded(
              child:
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
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start, // Zajistí zarovnání nahoru
                              children: [
                                Expanded(
                                  flex: 3, // Můžeš upravit podle potřeby
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
                                  flex: 4, // Odpověď dostane více místa
                                  child: Text(
                                    vocabulary["answer"]!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[600],
                                    ),
                                    overflow:
                                        TextOverflow
                                            .ellipsis, // Přidá "..." pokud je text příliš dlouhý
                                    maxLines: 2, // Omezení na 2 řádky
                                    softWrap: true, // Umožní zalamování textu
                                    textAlign:
                                        TextAlign
                                            .end, // Align text to the right
                                  ),
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
