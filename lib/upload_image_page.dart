import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage extends StatefulWidget {
  final String defaultImgUrl;
  const UploadImage({super.key, required this.defaultImgUrl});

  @override
  State<UploadImage> createState() => _UploadImage();
}

class _UploadImage extends State<UploadImage> {

  File? imageFile;

  Future<void> getImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  Future<void> takePicture() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  Future<void> cropImage(XFile pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
          const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }

  Future<void> uploadImageToFirebase() async {
    if (imageFile != null) {
      try {
        String extension = path.extension(imageFile!.path);
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}$extension');
        UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
        await uploadTask.whenComplete(() async {
          final newImageUrl = await firebaseStorageRef.getDownloadURL();
          if (context.mounted) GoRouter.of(context).pop(newImageUrl);
        });
      } catch (e) {
        print('Error uploading image to Firebase Storage: $e');
      }
    }
  }

  Widget _imageWidget() {
    if (imageFile == null) {
      if (widget.defaultImgUrl == '') return Image.asset('assets/default.jpg');
      return Image.network(widget.defaultImgUrl);
    } else {
      return Image.file(imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Change Image', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            GoRouter.of(context).pop('');
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: _imageWidget()
            ),
            const SizedBox(height: 20),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: takePicture,
                  child: const Text('Take an Image'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: getImageFromGallery,
                  child: const Text('Select Image'),
                )
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: imageFile != null ? uploadImageToFirebase : null,
              child: const Text('Submit'),
            ),
          ],
        )
      ),
    );
  }
}