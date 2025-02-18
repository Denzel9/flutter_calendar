import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DNEditableField extends StatefulWidget {
  final String title;
  final bool isEdit;
  final String editField;
  final int maxFontSize;
  final double minFontSize;
  final bool withTitle;
  final String docId;
  final Future<void> Function(
    String id,
    String field,
    String data,
  ) updateField;

  const DNEditableField({
    super.key,
    required this.title,
    required this.isEdit,
    required this.editField,
    required this.updateField,
    required this.docId,
    this.withTitle = true,
    this.maxFontSize = 40,
    this.minFontSize = 18,
  });

  @override
  State<DNEditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<DNEditableField> {
  final TextEditingController controller = TextEditingController();
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);

  Future<dynamic> setOpenEditBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              DNInput(
                controller: controller..clear(),
                autoFocus: true,
                countLines: 2,
                title: widget.editField.replaceFirst(
                  widget.editField[0],
                  widget.editField[0].toUpperCase(),
                ),
                onSubmitted: (String data) => setState(() {
                  if (controller.text.isNotEmpty) {
                    widget
                        .updateField(widget.docId, widget.editField, data)
                        .then((_) {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.withTitle
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.withTitle)
                Row(
                  children: [
                    DNText(
                      title: toUpperCase(widget.editField),
                      opacity: .5,
                      height: 2.2,
                      fontWeight: FontWeight.bold,
                    ),
                    if (widget.isEdit)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => setOpenEditBottomSheet()
                            .then((_) => setState(() {})),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn()
                  ],
                ),
              if (widget.title.isNotEmpty)
                AutoSizeText(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: widget.minFontSize,
                  maxLines: widget.maxFontSize,
                  overflow: TextOverflow.ellipsis,
                ),
              if (widget.title.isEmpty)
                GestureDetector(
                  onTap: () =>
                      setOpenEditBottomSheet().then((_) => setState(() {})),
                  child: DNText(
                    title: 'Add ${widget.editField}',
                  ),
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title.isNotEmpty)
                Row(
                  children: [
                    AutoSizeText(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: widget.minFontSize,
                      maxLines: widget.maxFontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.isEdit)
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => setOpenEditBottomSheet()
                            .then((_) => setState(() {})),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn()
                  ],
                ),
              if (widget.title.isEmpty)
                GestureDetector(
                  onTap: () =>
                      setOpenEditBottomSheet().then((_) => setState(() {})),
                  child: DNText(
                    title: 'Add ${widget.editField}',
                  ),
                ),
            ],
          );
  }
}
