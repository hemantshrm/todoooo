import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoooo/constants.dart';

enum AppState {
  free,
  picked,
  cropped,
}

class ImageController extends GetxController {
  File image;
  var state = AppState.free.obs;
  var downloadURL = ''.obs;
  final picker = ImagePicker();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    downloadURLfrmFirebase();
  }

  getImageFromGallery(ImageSource) async {
    final pickedImage = await picker.getImage(source: ImageSource);
    uploadFile(pickedImage.path);
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    await storage
        .ref('uploads/${firebaseAuth.currentUser.uid}/dp')
        .putFile(file);
  }

  Future<void> downloadURLfrmFirebase() async {
    String downloadURL = await storage
        .ref('uploads/${firebaseAuth.currentUser.uid}/dp')
        .getDownloadURL();
    this.downloadURL.value = downloadURL;

    await users.doc(firebaseAuth.currentUser.uid).update({'dp': downloadURL});
  }

  showPicker() {
    Get.defaultDialog(
      title: '',
      titleStyle: designStyle.copyWith(fontSize: 16),
      content: Column(
        children: [
          ListTile(
              leading: Icon(
                Icons.photo_library,
              ),
              title: Text(
                'Photo Library',
                style: designStyle.copyWith(fontSize: 16),
              ),
              onTap: () async {
                await getImageFromGallery(ImageSource.gallery);
                Get.back();
              }),
          ListTile(
              leading: Icon(
                Icons.camera_alt,
              ),
              title: Text('Camera', style: designStyle.copyWith(fontSize: 16)),
              onTap: () async {
                await getImageFromGallery(ImageSource.camera);
                Get.back();
              }),
        ],
      ),
    );
  }

  // Future<Null> cropImage() async {
  //   File croppedFile = await ImageCropper.cropImage(
  //       sourcePath: image.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.square,
  //             ]
  //           : [
  //               CropAspectRatioPreset.square,
  //             ],
  //       androidUiSettings: AndroidUiSettings(
  //           hideBottomControls: true,
  //           showCropGrid: true,
  //           toolbarColor: AppColors.appTheme,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));
  //   if (croppedFile != null) {
  //     image = croppedFile;
  //     state.value = AppState.cropped;
  //   }
  // }
}
