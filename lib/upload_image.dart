import 'dart:io';
import 'package:flutter/material.dart';
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

  String _imageUrl = '';

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

  Future<void> cropImage(XFile imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
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
      uploadImageToFirebase(File(croppedFile.path));
    }
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    try {
      String extension = path.extension(imageFile.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}$extension');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        final newImageUrl = await firebaseStorageRef.getDownloadURL();
        setState(() {
          _imageUrl = newImageUrl;
        });
      });
        } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Widget _imageWidget() {
    if (_imageUrl == '') {
      return Image.asset('assets/default.jpg');
    } else {
      return Image.network(_imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}