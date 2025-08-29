import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class HeroText extends StatelessWidget {
  HeroText({super.key});
  final colorizeColors = [
    const Color(0xFFCC2D3C),
    Colors.teal,
    Colors.black,
  ];
  final TextStyle colorizeTextStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, right: 3.0, left: 3.0),
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(
            'Get Auto Notify For Every Upcoming Cases',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
          ColorizeAnimatedText(
            'Fully Offline Supported',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
          ColorizeAnimatedText(
            'Automatic Data Backup to Google Cloud',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
          ColorizeAnimatedText(
            'There is No Advertisement',
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
          ),
        ],
        isRepeatingAnimation: true,
        repeatForever: true,
        stopPauseOnTap: true,
      ),
    );
  }
}
