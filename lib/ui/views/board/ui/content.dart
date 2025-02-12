import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatelessWidget {
  final ScrollController controller;
  final String title;

  const Content({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: filteredTaskToBoard(title, store.tasks).isNotEmpty
            ? ListView.builder(
                controller: controller,
                itemCount: filteredTaskToBoard(title, store.tasks).length,
                itemBuilder: (context, index) {
                  final task = filteredTaskToBoard(title, store.tasks)[index];
                  return InfoCard(
                    data: task,
                    index: index,
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const DNText(
                    title: 'Empty',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    opacity: .5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DNButton(
                    title: 'Add task',
                    isPrimary: false,
                    onClick: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CreatePage(
                            selectedBoard: title,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
      );
    });
  }
}
