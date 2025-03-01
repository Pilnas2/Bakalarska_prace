import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../background_gradient.dart'; // Importujte BackgroundGradient
import '../main.dart'; // Importujte LoginPage
import '../controllers/language_mapper.dart'; // Importujte LanguageMapper

class IntroductionPage extends StatelessWidget {
  final String language;

  const IntroductionPage({required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    final languageMapper = LanguageMapper(language);

    return Scaffold(
      body: BackgroundGradient(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: languageMapper.getTitle('welcome'),
              body: languageMapper.getBody('welcome'),
              image: Center(
                child: Image.asset(
                  "assets/images/logo_learnCzech.png",
                  height: 175.0,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.transparent, // Nastavte průhledné pozadí
              ),
            ),
            PageViewModel(
              title: languageMapper.getTitle('learn'),
              body: languageMapper.getBody('learn'),
              image: Center(
                child: Icon(Icons.school, size: 175.0, color: Colors.blue),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.transparent, // Nastavte průhledné pozadí
              ),
            ),
            PageViewModel(
              title: languageMapper.getTitle('get_started'),
              body: languageMapper.getBody('get_started'),
              image: Center(
                child: Icon(Icons.login, size: 175.0, color: Colors.green),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.transparent, // Nastavte průhledné pozadí
              ),
            ),
          ],
          onDone: () {
            // When done button is press
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage(language: language)),
            );
          },
          onSkip: () {
            // You can also override onSkip callback
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage(language: language)),
            );
          },
          showSkipButton: true,
          skip: Text(languageMapper.getTitle('skip')),
          next: const Icon(Icons.arrow_forward),
          done: Text(
            languageMapper.getTitle('done'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
