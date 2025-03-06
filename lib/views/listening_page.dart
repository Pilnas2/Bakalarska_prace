import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ListeningPage extends StatelessWidget {
  final List<Map<String, String>> sentences = [
    {"text": "Ahoj, jak se máš?", "audio": "hello.mp3"},
    {"text": "Dnes je krásné počasí.", "audio": "weather.mp3"},
    {"text": "Kde je nejbližší obchod?", "audio": "shop.mp3"},
  ];

  final AudioPlayer audioPlayer = AudioPlayer();

  ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Procvičování poslechu")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Poslechové věty",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: sentences.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        sentences[index]["text"]!,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.play_arrow),
                        onPressed: () {
                          audioPlayer.play(
                            AssetSource("audio/${sentences[index]['audio']}"),
                          );
                        },
                      ),
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
