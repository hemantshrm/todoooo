import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:todoooo/constants.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/login_Screen/loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  HomeController _homeController = Get.put(HomeController());

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'SignUp',
                style: designStyle.copyWith(fontSize: 40),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            LoginFields(
              hidetext: false,
              heading: "Name",
              icon: Icon(
                FontAwesomeIcons.personBooth,
                size: 20,
              ),
              keyboard: TextInputType.text,
              textEditingController: _homeController.name,
            ),
            SizedBox(
              height: 20,
            ),
            LoginFields(
              hidetext: false,
              heading: "Email",
              icon: Icon(
                FontAwesomeIcons.userSecret,
                size: 20,
              ),
              keyboard: TextInputType.emailAddress,
              textEditingController: _homeController.signUpEmail,
            ),
            SizedBox(
              height: 20,
            ),
            LoginFields(
              hidetext: false,
              heading: "Password",
              icon: Icon(
                FontAwesomeIcons.lock,
                size: 20,
              ),
              keyboard: TextInputType.visiblePassword,
              textEditingController: _homeController.signUpPass,
            ),
            SizedBox(
              height: 20,
            ),
            RoundedLoadingButton(
              successColor: Colors.green,
              color: AppColors.appTheme,
              child: Text('Register',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              controller: _homeController.btnController,
              onPressed: () async {
                try {
                  final newUser =
                      await firebaseAuth.createUserWithEmailAndPassword(
                          email: _homeController.signUpEmail.text,
                          password: _homeController.signUpPass.text);
                  if (newUser != null) {
                    _homeController.addUser();
                  } else {
                    _homeController.resetLoader();
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    _homeController
                        .errorSnackbar('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    _homeController.errorSnackbar(
                        'The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                } finally {
                  _homeController.resetLoader();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
