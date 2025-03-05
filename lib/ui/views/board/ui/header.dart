import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/controller/controller.dart';

class Header extends StatelessWidget {
  final String id;
  final String title;

  const Header({
    super.key,
    required this.title,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DNIconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
              ),
              backgroundColor: Colors.amberAccent,
              onClick: () => Navigator.pop(context),
            ),
            PopupMenuButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
              ),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  onTap: () async {
                    final findedBoards = filteredTaskToBoard(title, store);

                    if (findedBoards.isEmpty) {
                      await boardService.deleteBoard(id);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'There are ${findedBoards.length} tasks that cannot be deleted'),
                        ),
                      );
                    }
                  },
                  child: const DNText(
                    title: 'Delete',
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
