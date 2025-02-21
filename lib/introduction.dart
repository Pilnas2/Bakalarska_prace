import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'background_gradient.dart'; // Importujte BackgroundGradient
import 'main.dart'; // Importujte LoginPage

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradient(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Welcome",
              body:
                  "Welcome to Learn Czech, the best app to learn Czech language.",
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
              title: "Learn",
              body: "Learn Czech with interactive lessons and quizzes.",
              image: Center(
                child: Icon(Icons.school, size: 175.0, color: Colors.blue),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.transparent, // Nastavte průhledné pozadí
              ),
            ),
            PageViewModel(
              title: "Get Started",
              body: "Sign up or log in to start learning Czech today!",
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
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          onSkip: () {
            // You can also override onSkip callback
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          },
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Icon(Icons.arrow_forward),
          done: const Text(
            "Done",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
