import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/core/provider/app_provider.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class DNEditableField extends StatefulWidget {
  final String title;
  final bool isEdit;
  final String editField;
  final TextEditingController controller;
  final String taskId;
  final double? maxFontSize;

  const DNEditableField(
      {super.key,
      required this.title,
      required this.isEdit,
      required this.editField,
      required this.controller,
      required this.taskId,
      this.maxFontSize});

  @override
  State<DNEditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<DNEditableField> {
  Future<dynamic>? setOpenEditBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      context: context,
      builder: (context) {
        return KeyboardAvoider(
          autoScroll: true,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                DNInput(
                  controller: widget.controller,
                  title: widget.editField.replaceFirst(
                    widget.editField[0],
                    widget.editField[0].toUpperCase(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: DNButton(
                    title: 'Save',
                    onClick: () {
                      if (widget.controller.text.isNotEmpty) {
                        context
                            .read<TaskServiceImpl>()
                            .updateField(
                              widget.taskId,
                              widget.editField,
                              widget.controller.text,
                            )
                            .then(
                          (_) {
                            if (context.mounted) {
                              // Navigator.pop(context);
                            }
                            widget.controller.clear();
                          },
                        );
                      }
                    },
                    isPrimary: true,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.title.isNotEmpty)
          AutoSizeText(
            widget.title,
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 18,
            maxFontSize: widget.maxFontSize ?? 20,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        if (widget.title.isEmpty)
          GestureDetector(
            onTap: setOpenEditBottomSheet,
            child: const DNText(
              title: 'Add',
              opacity: .5,
            ),
          ),
        if (widget.isEdit)
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setOpenEditBottomSheet(),
            icon: const Icon(Icons.edit, color: Colors.white),
          )
      ],
    );
  }
}
