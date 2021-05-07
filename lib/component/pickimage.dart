// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:todoooo/constants.dart';
//
// enum AppState {
//   free,
//   picked,
//   cropped,
// }
//
// class ImageController extends GetxController {
//   File image;
//   AppState state;
//   final picker = ImagePicker();
//
//   @override
//   void onInit() {
//     super.onInit();
//     state = AppState.free;
//   }
//
//   getImageFromGallery() async {
//     final pickedImage = await picker.getImage(source: ImageSource.gallery);
//     image = pickedImage != null ? File(pickedImage.path) : null;
//     // if (image != null) {
//     //   // cropImage();
//     // }
//
//     return image;
//   }
//
//   void clearImage() {
//     image = null;
//   }
//
//   showPicker({Function(File) onselect}) {
//     Get.bottomSheet(Container(
//       color: Colors.white,
//       child: ListTile(
//           leading: Icon(Icons.photo_library),
//           title: Text('Photo Library'),
//           onTap: () async {
//             File image = await getImageFromGallery();
//             onselect(image);
//             Get.back();
//           }),
//     ));
//   }
//
//   // Future<Null> cropImage() async {
//   //   File croppedFile = await ImageCropper.cropImage(
//   //       sourcePath: image.path,
//   //       aspectRatioPresets: Platform.isAndroid
//   //           ? [
//   //               CropAspectRatioPreset.square,
//   //             ]
//   //           : [
//   //               CropAspectRatioPreset.square,
//   //             ],
//   //       androidUiSettings: AndroidUiSettings(
//   //           hideBottomControls: true,
//   //           showCropGrid: true,
//   //           toolbarColor: AppColors.appTheme,
//   //           toolbarWidgetColor: Colors.white,
//   //           initAspectRatio: CropAspectRatioPreset.original,
//   //           lockAspectRatio: false),
//   //       iosUiSettings: IOSUiSettings(
//   //         title: 'Cropper',
//   //       ));
//   //   if (croppedFile != null) {
//   //     image = croppedFile;
//   //     setState(() {
//   //       state = AppState.cropped;
//   //     });
//   //   }
//   // }
// }
