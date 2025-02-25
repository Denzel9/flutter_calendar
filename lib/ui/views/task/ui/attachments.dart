import 'dart:io';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/utils/parse_link_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Attachments extends StatefulWidget {
  final String docId;
  final bool isDone;
  const Attachments({
    super.key,
    required this.docId,
    required this.isDone,
  });

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  final ImagePicker imagePicker = ImagePicker();

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
                          await pickImage(taskStoreLocal);

                          await taskService.addAttachments(
                              taskStoreLocal.image, widget.docId);

                          setState(() {
                            taskService.isLoading = false;
                          });
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    useSafeArea: false,
                    builder: (BuildContext context) => FullScreenCarousel(
                      images: snapshot.data,
                      initImage: index,
                    ),
                  ),
                  onLongPress: () {
                    if (!widget.isDone) {
                      setState(() {
                        taskStoreLocal.isEdit = true;
                      });
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DNImage(
                        url: snapshot.data![index],
                      ),
                      if (taskStoreLocal.isEdit)
                        Positioned(
                          right: -10,
                          top: -13,
                          child: DNIconButton(
                            key: GlobalKey(),
                            backgroundColor: Theme.of(context).primaryColorDark,
                            color: Colors.red,
                            icon: const Icon(Icons.cancel),
                            onClick: () async {
                              await taskService.deleteAttachments(
                                widget.docId,
                                parseLinkImage(snapshot.data![index]),
                              );

                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () => setState(() {}),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}

class FullScreenCarousel extends StatelessWidget {
  final int initImage;
  final List<String>? images;
  const FullScreenCarousel(
      {super.key, required this.images, required this.initImage});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.black54,
          body: Center(
            child: FlutterCarousel(
              options: FlutterCarouselOptions(
                initialPage: initImage,
                height: 400.0,
                viewportFraction: 1,
                showIndicator: true,
                slideIndicator: CircularSlideIndicator(),
              ),
              items: List.generate(
                images?.length ?? 0,
                (index) => DNImage(url: images?[index] ?? ''),
              ),
            ),
          ),
        ),
      );
}
