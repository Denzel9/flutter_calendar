// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ImageStore on ImageStoreBase, Store {
  late final _$fileImagesAtom =
      Atom(name: 'ImageStoreBase.fileImages', context: context);

  @override
  List<File> get fileImages {
    _$fileImagesAtom.reportRead();
    return super.fileImages;
  }

  @override
  set fileImages(List<File> value) {
    _$fileImagesAtom.reportWrite(value, super.fileImages, () {
      super.fileImages = value;
    });
  }

  late final _$stringImagesAtom =
      Atom(name: 'ImageStoreBase.stringImages', context: context);

  @override
  List<ImageData> get stringImages {
    _$stringImagesAtom.reportRead();
    return super.stringImages;
  }

  @override
  set stringImages(List<ImageData> value) {
    _$stringImagesAtom.reportWrite(value, super.stringImages, () {
      super.stringImages = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: 'ImageStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$addImageAsyncAction =
      AsyncAction('ImageStoreBase.addImage', context: context);

  @override
  Future<XFile?> addImage({bool isPickImage = false}) {
    return _$addImageAsyncAction
        .run(() => super.addImage(isPickImage: isPickImage));
  }

  late final _$ImageStoreBaseActionController =
      ActionController(name: 'ImageStoreBase', context: context);

  @override
  void removeImage(int index) {
    final _$actionInfo = _$ImageStoreBaseActionController.startAction(
        name: 'ImageStoreBase.removeImage');
    try {
      return super.removeImage(index);
    } finally {
      _$ImageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
fileImages: ${fileImages},
stringImages: ${stringImages},
isLoading: ${isLoading}
    ''';
  }
}
