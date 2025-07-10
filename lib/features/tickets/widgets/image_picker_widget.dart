import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final List<File> initialImages;
  final Function(List<File>) onImagesSelected;

  const ImagePickerWidget({
    super.key,
    required this.initialImages,
    required this.onImagesSelected,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  late List<File> _images;

  @override
  void initState() {
    super.initState();
    _images = widget.initialImages;
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles.map((e) => File(e.path)).toList();
      });
      widget.onImagesSelected(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _images
              .map((img) => Image.file(img, width: 100, height: 100, fit: BoxFit.cover))
              .toList(),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          icon: const Icon(Icons.add_a_photo),
          label: const Text('Add Photos'),
          onPressed: _pickImages,
        ),
      ],
    );
  }
}