import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../core/controller/controller.dart';

class Header extends StatelessWidget {
  final String id;
  final String title;
  final int countTask;
  final TabController controller;

  const Header({
    super.key,
    required this.controller,
    required this.title,
    required this.countTask,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DNIconButton(
                icon: const Icon(
                  Icons.arrow_downward,
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
        ),
        TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.amberAccent,
          unselectedLabelColor: Colors.white54,
          labelColor: Colors.amberAccent,
          overlayColor: WidgetStateProperty.all(
              Colors.amberAccent.withAlpha((0.1 * 255).toInt())),
          tabs: [
            Observer(
              builder: (_) => Tab(
                height: 50,
                child: DNText(
                  title: '${filteredTaskToBoard(title, store).length} Tasks',
                  fontSize: 25,
                  color:
                      controller.index == 0 ? Colors.amberAccent : Colors.white,
                ),
              ),
            ),
            Tab(
              height: 50,
              child: DNText(
                title: 'Information',
                fontSize: 25,
                color:
                    controller.index == 1 ? Colors.amberAccent : Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }
}
