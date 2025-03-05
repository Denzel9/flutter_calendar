import 'package:calendar_flutter/store/image_store/image_store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/ui/empty_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Attachments extends StatefulWidget {
  final Future<void> Function()? voidCallback;
  final VoidCallback deleteCallback;
  final void Function(ImageData) addToDelete;
  final List<String> deleteList;
  final bool isDeleting;
  final bool withTitle;

  const Attachments({
    super.key,
    this.withTitle = false,
    this.voidCallback,
    required this.deleteCallback,
    required this.isDeleting,
    required this.addToDelete,
    required this.deleteList,
  });

  @override
  State<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final ImagePicker imagePicker = ImagePicker();
  late final ImageStore store;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    store = context.watch<ImageStore>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    store.fileImages = [];
    controller.dispose();
    super.dispose();
  }

  void toggleShake() {
    setState(() {
      widget.deleteCallback();
      if (widget.isDeleting) {
        controller.repeat(reverse: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ImageStore store = context.watch<ImageStore>();

    return Observer(
      builder: (_) => store.fileImages.isEmpty && store.stringImages.isEmpty
          ? const EmptyList(title: 'Attachments is empty')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.withTitle)
                  Row(
                    children: [
                      const DNText(
                        title: 'Attachments',
                        opacity: .5,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: store.isLoading
                            ? const CircularProgressIndicator()
                            : DNIconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 15,
                                ),
                                onClick: () => setState(() {
                                  store.addImage(isPickImage: true).then((_) {
                                    if (context.mounted) {
                                      setState(() {});
                                    }
                                  });
                                }),
                              ),
                      )
                    ],
                  ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 120),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: store.stringImages.isNotEmpty
                        ? store.stringImages.length
                        : store.fileImages.length,
                    itemBuilder: (BuildContext context, int index) =>
                        AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => Transform.rotate(
                        angle: .05 * controller.value,
                        child: Stack(fit: StackFit.expand, children: [
                          GestureDetector(
                            onLongPress: () => toggleShake(),
                            child: store.stringImages.isNotEmpty
                                ? DNImage(url: store.stringImages[index].url)
                                : Image.file(
                                    store.fileImages[index],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: Transform.scale(
                              scale: 1.5,
                              child: Radio(
                                fillColor:
                                    WidgetStateProperty.all(Colors.white),
                                value: store.stringImages[index],
                                groupValue: widget.deleteList
                                    .contains(store.stringImages[index].id),
                                toggleable: true,
                                onChanged: (value) {
                                  print(widget.deleteList
                                      .contains(store.stringImages[index].id));
                                  setState(() {
                                    widget.addToDelete(value as ImageData);
                                  });
                                },
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
