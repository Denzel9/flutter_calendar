import 'dart:io';

import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Media extends StatefulWidget {
  const Media({super.key});

  @override
  State<Media> createState() => _MediaState();
}

class _MediaState extends State<Media> {
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickImage(File? image) async {
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null) {
      setState(() {
        image = File(xFileImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CreateStoreLocal store = CreateStoreLocal();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DNText(
          title: 'Media',
          opacity: .5,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        if (store.image?.path.isEmpty ?? false)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: DNIconButton(
              onClick: () => pickImage(store.image),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        // add component AttachmentImage
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              if (store.image?.path.isNotEmpty ?? false)
                Image.file(
                  store.image as File,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              if (store.image?.path.isNotEmpty ?? false)
                const SizedBox(
                  width: 10,
                ),
              DNIconButton(icon: const Icon(Icons.add), onClick: () {})
            ],
          ),
        )
      ],
    );
  }
}
