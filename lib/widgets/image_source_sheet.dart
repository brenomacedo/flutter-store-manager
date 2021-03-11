import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  final Function(File) onImageSelected;

  ImageSourceSheet({this.onImageSelected});

  final ImagePicker picker = ImagePicker();

  void imageSelected(File image) async {
    if(image != null) {
      File croppedImage = await ImageCropper.cropImage(sourcePath: image.path);
      onImageSelected(croppedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              child: Text('Câmera'),
              onPressed: () async {
                PickedFile pickedImage = await picker.getImage(source: ImageSource.camera);
                File image = File(pickedImage.path);
                imageSelected(image);
              },
            ),
            TextButton(
              child: Text('Galeria'),
              onPressed: () async {
                PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
                File image = File(pickedImage.path);
                imageSelected(image);
              },
            )
          ],
        );
      },
      onClosing: () {},
    );
  }
}