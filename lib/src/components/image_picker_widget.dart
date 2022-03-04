import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef OnImageSelected = Function(File imageFile);

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final String? assetPath;
  final OnImageSelected onImageSelected;

  const ImagePickerWidget(
      {this.imageFile, this.assetPath, required this.onImageSelected, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.shade300,
            Colors.cyan.shade800,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        image: imageFile != null
            ? DecorationImage(
                image: FileImage(imageFile!),
                fit: BoxFit.cover,
              )
            : assetPath != null
                ? DecorationImage(
                    image: AssetImage(assetPath!),
                    fit: BoxFit.cover,
                  )
                : null,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.camera_alt,
        ),
        onPressed: () => _showPickerOptions(context),
        iconSize: 90,
        color: Colors.white,
      ),
    );
  }

  void _showPickerOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
              ),
              title: const Text("Camara"),
              onTap: () {
                Navigator.pop(context);
                _showPickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Galería"),
              onTap: () {
                Navigator.pop(context);
                _showPickImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPickImage(BuildContext context, source) async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: source);
    onImageSelected(File(image!.path));
  }
}
