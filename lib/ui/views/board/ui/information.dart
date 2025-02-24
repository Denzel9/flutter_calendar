import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';

class Information extends StatefulWidget {
  final Board? board;

  const Information({super.key, required this.board});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            const DNText(
              title: 'Board',
              opacity: .5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AutoSizeText(
                widget.board?.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 30,
                maxFontSize: 40,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const DNText(
              title: 'CreatedAt',
              opacity: .5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: DNText(
                title: getFormatDate(widget.board?.createdAt ?? ''),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DNEditableField(
              title: widget.board?.description ?? '',
              isEdit: false,
              editField: 'description',
              docId: widget.board?.docId ?? '',
              updateField: boardService.updateField,
            ),
          ],
        ),
      );
}
