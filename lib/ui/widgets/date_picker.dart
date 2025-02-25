import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/cupertino.dart';

class DatePicker extends StatefulWidget {
  final String title;
  final void Function(DateTime) onChanged;

  const DatePicker({
    super.key,
    required this.title,
    required this.onChanged,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => Container(
            height: 250,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.dateAndTime,
                use24hFormat: true,
                onDateTimeChanged: widget.onChanged,
              ),
            ),
          ),
        ),
        child: DNText(
          title: widget.title,
          opacity: .5,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
}
