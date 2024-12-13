import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';

class DNCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;

  const DNCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.description});

  @override
  State<DNCard> createState() => _CardState();
}

class _CardState extends State<DNCard> {
  bool isOpenJob = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isOpenJob = !isOpenJob),
      child: AnimatedContainer(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 10),
        height: isOpenJob ? 400 : 90,
        width: double.infinity,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DNText(
              title: widget.title,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            DNText(
              title: widget.subtitle,
              color: Colors.black,
            ),
            if (isOpenJob)
              const AutoSizeText(
                'In the following guide, I want to show you what to say and how to say it when talking about your job. You may be required to talk about your job at a party or a social event. But you may also have to talk about your job if you are changing from one company to another and having interviews. In any situation, if you are working you should be able to express yourself in English when talking about your job.',
                style: TextStyle(color: Colors.black),
                minFontSize: 18,
                maxFontSize: 18,
              ),
          ],
        ),
      ),
    );
  }
}
