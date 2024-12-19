import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  final String title;
  final String createdAt;
  final String description;

  const Information(
      {super.key,
      required this.title,
      required this.createdAt,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          const DNText(
            title: 'Board',
            opacity: .5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AutoSizeText(title,
                style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.bold),
                minFontSize: 18,
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DNText(
                title: 'CreatedAt',
                opacity: .5,
              ),
              DNText(
                title: 'Assignee',
                opacity: .5,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DNText(
                title: getFormatDate(createdAt),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.centerRight,
                  children: [
                    Positioned(
                        child: CircleAvatar(backgroundColor: Colors.red)),
                    Positioned(
                      right: 25,
                      child: CircleAvatar(backgroundColor: Colors.black),
                    ),
                  ],
                ),
              )
            ],
          ),
          const DNText(
            title: 'Description',
            opacity: .5,
          ),
          AutoSizeText(
            description,
            minFontSize: 16,
            maxFontSize: 16,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
