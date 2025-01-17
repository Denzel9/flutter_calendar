import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Attachments extends StatefulWidget {
  final String docId;
  final bool isDone;
  const Attachments({super.key, required this.docId, required this.isDone});

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  final ImagePicker imagePicker = ImagePicker();
  final TaskServiceImpl taskService = TaskServiceImpl();

  Future<void> pickImage(TaskStoreLocal store) async {
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null) {
      setState(() {
        store.image.add(File(xFileImage.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();

    return FutureBuilder(
      future: taskService.getAttachments(widget.docId),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const DNText(
                  title: 'Attachments',
                  opacity: .5,
                ),
                const SizedBox(
                  width: 10,
                ),
                if (!widget.isDone)
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: taskService.isLoading
                        ? const CircularProgressIndicator()
                        : DNIconButton(
                            icon: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                            onClick: () async {
                              await pickImage(taskStoreLocal)
                                  .then(
                                    (_) => taskService.addAttachments(
                                        taskStoreLocal.image, widget.docId),
                                  )
                                  .then(
                                    (_) => setState(() {
                                      taskService.isLoading = false;
                                    }),
                                  );
                            },
                          ),
                  )
              ],
            ),
            FutureBuilder(
              future: taskService.getAttachments(widget.docId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.isEmpty ?? true) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 100),
                      child: DNText(title: 'Empty'),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    padding: snapshot.data?.isEmpty ?? true
                        ? null
                        : const EdgeInsets.only(bottom: 100, top: 20),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return CachedNetworkImage(
                        imageUrl: snapshot.data![index],
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            )
          ],
        );
      },
    );
  }
}
