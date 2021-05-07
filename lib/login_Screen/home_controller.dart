import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:todoooo/mainScreen/MainScreen.dart';

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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
      'name': name.text,
      'email': signUpEmail.text,
      'userId': firebaseAuth.currentUser.uid,
      'createdDate': DateTime.now().toUtc().millisecondsSinceEpoch,
    }).then((value) {
      Get.toNamed(TodoScreen.id);
    }).catchError((error) => print("Failed to add user: $error"));
  }

  void getUserName() async {
    users.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["name"]);
      });
    });
  }
}
