import 'package:flutter/material.dart';

class DNSelect extends StatelessWidget {
  final List<String> boards;
  final String value;
  final Function(String?) onClick;
  const DNSelect(
      {super.key,
      required this.boards,
      required this.value,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: const Color.fromARGB(255, 85, 84, 84),
      isExpanded: true,
      iconSize: 40,
      items: boards.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withOpacity(.5),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
      value: value,
      onChanged: onClick,
    );
  }
}
