import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/ui/chart.dart';
import 'package:calendar_flutter/ui/views/board/ui/header.dart';
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
  Widget build(BuildContext context) => SliverAppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        pinned: true,
        toolbarHeight: 0,
        expandedHeight: 370,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: widget.board?.title ?? '',
                id: widget.board?.docId ?? '',
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DNText(
                          title:
                              'CreatedAt: ${getFormatDate(widget.board?.createdAt ?? '')}',
                          opacity: .5,
                          fontSize: 14,
                        ),
                        const SizedBox(height: 10),
                        const DNText(
                          title: 'Board progress',
                          fontSize: 18,
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            ClipOval(
                              child: ColoredBox(
                                color: Colors.amber,
                                child: SizedBox(width: 10, height: 10),
                              ),
                            ),
                            SizedBox(width: 5),
                            DNText(title: 'Tasks', fontSize: 14),
                            SizedBox(width: 5),
                            ClipOval(
                              child: ColoredBox(
                                color: Colors.purple,
                                child: SizedBox(width: 10, height: 10),
                              ),
                            ),
                            SizedBox(width: 5),
                            DNText(title: 'Subtasks', fontSize: 14),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DNButton(
                          title: 'Statistics',
                          onClick: () {},
                          isPrimary: false,
                          height: 35,
                        )
                      ],
                    ),
                    const PieChart(
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
              ),
              DNEditableField(
                title: widget.board?.description ?? '',
                isEdit: false,
                editField: 'description',
                docId: widget.board?.docId ?? '',
                updateField: boardService.updateField,
                maxFontSize: 18,
              ),
            ],
          ),
        ),
      );
}
