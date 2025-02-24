import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DNSelect extends StatelessWidget {
  final List<String> boards;
  final String value;
  final String? initialValue;

  final Function(int index) onClick;
  const DNSelect(
      {super.key,
      required this.boards,
      required this.value,
      required this.onClick,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    final int findedValue = boards.indexOf(initialValue ?? value);

    return GestureDetector(
      child: Row(
        children: [
          DNText(
            title:
                toUpperCase(initialValue != null ? boards[findedValue] : value),
            fontWeight: FontWeight.bold,
            fontSize: 25,
            opacity: .5,
          ),
          const Icon(
            Icons.arrow_right,
            color: Colors.white54,
            size: 30,
          )
        ],
      ),
      onTap: () => showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
          height: 300,
          color: Theme.of(context).primaryColorDark,
          child: SafeArea(
            top: false,
            child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 32,
              scrollController: FixedExtentScrollController(
                initialItem: findedValue,
              ),
              onSelectedItemChanged: onClick,
              children: List.generate(
                boards.length,
                (int index) {
                  return Center(
                    child: DNText(
                      title: boards[index],
                      fontSize: 20,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
