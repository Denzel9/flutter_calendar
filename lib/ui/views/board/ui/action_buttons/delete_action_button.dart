import 'dart:io';

import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/image_store/image_store.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:calendar_flutter/utils/parse_link_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteActionButton extends StatefulWidget {
  final TabController tabController;
  final Future<void> Function() voidCallback;
  final String board;

  const DeleteActionButton({
    super.key,
    required this.tabController,
    required this.board,
    required this.voidCallback,
  });

  @override
  State<DeleteActionButton> createState() => _DeleteActionButtonState();
}

class _DeleteActionButtonState extends State<DeleteActionButton> {
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
                // if (imageStore.stringImages.isNotEmpty) {
                //   taskService.deleteAttachments(
                //     imageStore.stringImages[index].id,
                //     parseLinkImage(store.stringImages[index].url),
                //   );
                //   widget.voidCallback();
                //   setState(() {
                //     taskService.isLoading = false;
                //   });
                // } else {
                //   imageStore.removeImage(index);
                // }
              }
            },
            child: const Icon(Icons.delete),
          );
  }
}
