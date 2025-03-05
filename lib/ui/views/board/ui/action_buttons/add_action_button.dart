import 'dart:io';

import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/image_store/image_store.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddActionButton extends StatefulWidget {
  final TabController tabController;
  final Future<void> Function() voidCallback;
  final String board;

  const AddActionButton({
    super.key,
    required this.tabController,
    required this.board,
    required this.voidCallback,
  });

  @override
  State<AddActionButton> createState() => _AddActionButtonState();
}

class _AddActionButtonState extends State<AddActionButton> {
  @override
  Widget build(BuildContext context) {
    final ImageStore imageStore = context.watch<ImageStore>();
    final AppStore store = context.watch<AppStore>();

    return taskService.isLoading
        ? const CircularProgressIndicator()
        : FloatingActionButton(
            onPressed: () {
              if (widget.tabController.index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatePage(selectedBoard: widget.board),
                  ),
                );
              }
              if (widget.tabController.index == 2) {
                // Add link
              }
              if (widget.tabController.index == 2) {
                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      final tasks = filteredTaskToBoard(widget.board, store);
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            const Text('Select a task to add a photo to'),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: tasks.length,
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return ListTile(
                                      title: Text(task.title),
                                      trailing: taskService.isLoading
                                          ? const CircularProgressIndicator()
                                          : const Icon(Icons.add),
                                      subtitle:
                                          Text('Attachments ${task.docId}'),
                                      onTap: () async {
                                        final image =
                                            await imageStore.addImage();
                                        setState(() {
                                          taskService.isLoading = true;
                                          Navigator.pop(context);
                                        });

                                        if (image != null) {
                                          await taskService.addAttachments(
                                              [File(image.path)],
                                              task.docId ?? '');

                                          await widget.voidCallback();

                                          setState(() {
                                            taskService.isLoading = false;
                                          });
                                        }
                                      },
                                    );
                                  }),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              }
            },
            child: const Icon(Icons.add),
          );
  }
}
