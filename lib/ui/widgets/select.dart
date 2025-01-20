import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DNSelect extends StatelessWidget {
  final List<String> boards;
  final String value;
  final Function(int index) onClick;
  const DNSelect(
      {super.key,
      required this.boards,
      required this.value,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          DNText(
            title: value,
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
      onTap: () {
        showCupertinoModalPopup(
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
                  initialItem: boards.indexOf(value),
                ),
                onSelectedItemChanged: onClick,
                children: List.generate(boards.length, (int index) {
                  return Center(
                    child: DNText(
                      title: boards[index],
                      fontSize: 20,
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
