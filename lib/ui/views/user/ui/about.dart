import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/ui/widgets/card.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),
        AutoSizeText(
          'In the following guide, I want to show you what to say and how to say it when talking about your job. You may be required to talk about your job at a party or a social event. But you may also have to talk about your job if you are changing from one company to another and having interviews. In any situation, if you are working you should be able to express yourself in English when talking about your job.',
          style: TextStyle(color: Colors.white),
          minFontSize: 18,
          maxFontSize: 18,
        ),
        SizedBox(height: 20),
        DNCard(
          title: 'following guide',
          subtitle: 'following guide',
          description: 'following guide',
        ),
        DNCard(
          title: 'following guide',
          subtitle: 'following guide',
          description: 'following guide',
        ),
        DNCard(
          title: 'following guide',
          subtitle: 'following guide',
          description: 'following guide',
        ),
      ],
    );
  }
}
