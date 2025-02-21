import 'package:bakalarska_prace_pilny/background_gradient.dart';
import 'package:flutter/material.dart';
import 'introduction.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BackgroundGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            AppBar(
              title: const Text('Select Language'),
              centerTitle: true, // Zarovná text na střed
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Set language to Czech and navigate to IntroductionPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const IntroductionPage()),
                );
              },
              child: const Text('Česky'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Set language to English and navigate to IntroductionPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const IntroductionPage()),
                );
              },
              child: const Text('English'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Set language to Russian and navigate to IntroductionPage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const IntroductionPage()),
                );
              },
              child: const Text('Русски'),
            ),
          ],
        ),
      ),
    );
  }
}
