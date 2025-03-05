import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'image_store.g.dart';

final ImagePicker imagePicker = ImagePicker();

class ImageStore = ImageStoreBase with _$ImageStore;

abstract class ImageStoreBase with Store {
  @observable
  List<File> fileImages = [];

  @observable
  List<ImageData> stringImages = [];

  @observable
  bool isLoading = false;

  @action
  Future<XFile?> addImage({bool isPickImage = false}) async {
    isLoading = true;
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null && isPickImage) {
      fileImages.add(File(xFileImage.path));
    }
    isLoading = false;
    return xFileImage;
  }

  @action
  void removeImage(int index) => fileImages.removeAt(index);
}

class ImageData {
  final String id;
  final String url;

  ImageData(this.id, this.url);
}
