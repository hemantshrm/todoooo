import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todoooo/todoScreen/Todo_Screen.dart';

class HomeController extends GetxController {
  final RoundedLoadingButtonController btnController =
      new RoundedLoadingButtonController();

  var loginEmail = TextEditingController();
  var loginPassword = TextEditingController();
  var chatting = TextEditingController();
  var name = TextEditingController();
  var signUpEmail = TextEditingController();
  var signUpPass = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference todoServer =
      FirebaseFirestore.instance.collection('todos');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GetStorage userInfoStorage = GetStorage();

  void resetLoader() async {
    Timer(Duration(seconds: 2), () {
      btnController.reset();
    });
  }

  void errorSnackbar(String msg) {
    Get.rawSnackbar(title: "Error", borderRadius: 7, message: "$msg");
  }

  Future<void> addUser() {
    return users.doc(firebaseAuth.currentUser.uid).set({
      'name': name.text.capitalizeFirst,
      'email': signUpEmail.text.capitalizeFirst,
      'userId': firebaseAuth.currentUser.uid,
      'createdDate': DateTime.now().toUtc().millisecondsSinceEpoch,
      'dp': ''
    }).then((value) {
      Get.offAndToNamed(TodoScreen.id);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> delete(String id) {
    return todoServer
        .doc(firebaseAuth.currentUser.uid)
        .collection('list')
        .doc(id)
        .delete()
        .then((value) => print("Deleted"));
  }

  String getTime_forTODO(String timestamp) {
    String formattedDate = 'NA';
    try {
      formattedDate =
          DateFormat('EEE dd-MM-yy').add_jm().format(DateTime.parse(timestamp));
    } catch (e) {
      print(e);
    }

    if (formattedDate == 'NA') {
      return 'NA';
    } else {
      return formattedDate;
    }
  }

  String getTime_forChat(String timestamp) {
    String formattedDate = 'NA';
    try {
      formattedDate = DateFormat('jm').format(DateTime.parse(timestamp));
    } catch (e) {
      print(e);
    }

    if (formattedDate == 'NA') {
      return 'NA';
    } else {
      return formattedDate;
    }
  }
}
