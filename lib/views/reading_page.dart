import 'package:flutter/material.dart';

class ReadingPage extends StatelessWidget {
  final String storyTitle = "O chytré lišce";
  final String storyText = """
Jednoho dne se chytrá liška vydala do lesa hledat něco k jídlu. 
Narazila na farmu, kde uviděla slepice v kurníku. 
Liška věděla, že se musí chovat opatrně, aby ji nikdo nechytil. 
Přemýšlela a vymyslela plán, jak se dostat dovnitř.
""";

  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Čtení s porozuměním")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storyTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  storyText,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
