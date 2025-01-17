import 'dart:io';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickImage(CreateStoreLocal store) async {
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
    final CreateStoreLocal store = context.watch<CreateStoreLocal>();

    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const DNText(
                  title: 'Media',
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
                  child: DNIconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 15,
                    ),
                    onClick: () => pickImage(store),
                  ),
                )
              ],
            ),
            if (store.image.length == 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Image.file(
                      store.image[0],
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            if (store.image.length > 1)
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: store.image.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(
                    store.image[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
