import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;

  ImageInput(this.onSelectedImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final _imagePicker = ImagePicker();
    final imagePickedFile =
        await _imagePicker.getImage(source: ImageSource.camera, maxWidth: 600);

    if (imagePickedFile == null) return;
    setState(() {
      _storedImage = File(imagePickedFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName =  path.basename(imagePickedFile.path);
    final savedImage = await File(imagePickedFile.path)
        .copy('${appDir.path}/$fileName');
    widget.onSelectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 164,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image to Preview',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () {
              _takePicture();
            },
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
