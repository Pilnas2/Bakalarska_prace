import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff7BD3EA), Color(0xffA1EEBD)],
          stops: [0, 1],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: child,
    );
  }
}
