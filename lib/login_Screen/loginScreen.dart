import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoooo/controller/auth_controller.dart';
import 'package:todoooo/mainScreen/MainScreen.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'account_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AuthController authController = Get.put(AuthController());
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 30, end: 50).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.grey[300],
                    //       spreadRadius: 10,
                    //       blurRadius: 15,
                    //       offset: Offset(0, 10))
                    // ],
                    image: DecorationImage(
                        image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
              ),
              Positioned(
                  bottom: 80,
                  left: 20,
                  child: Text("Welcome ,", style: designStyle)),
              Align(
                alignment: Alignment.bottomCenter,
                child: TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 100),
                  repeatForever: false,
                  totalRepeatCount: 2,
                  text: ['To-Duh'],
                  textStyle: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => MainButtons(
                    width: animation.value,
                    imagePath: "images/fingerprint.png",
                    color: authController.hasFingerPrintLock.value
                        ? Colors.green
                        : Colors.grey,
                    onpressed: () async {
                      bool isauth = await authController.authenticateUser();
                      if (isauth) {
                        Navigator.pushNamed(context, MainScreen.id);
                      } else {
                        Get.snackbar("Error", "User Not Identified",
                            backgroundColor: Colors.red.shade500,
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  ),
                ),
                Obx(
                  () => MainButtons(
                    width: animation.value,
                    imagePath: "images/faceid.png",
                    color: authController.hasFaceLock.value
                        ? Colors.green
                        : Colors.grey,
                    onpressed: () async {
                      if (Platform.isIOS) {
                        bool isauth = await authController.authenticateUser();
                        isauth
                            ? Navigator.pushNamed(context, MainScreen.id)
                            : Get.snackbar("Error", "User Not Identify");
                      } else {
                        Get.defaultDialog(
                            title: "SORRY",
                            middleText: "FaceID needs an IOS device.");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MainButtons extends StatelessWidget {
  MainButtons(
      {@required this.onpressed, this.imagePath, this.color, this.width});
  final Function onpressed;
  final String imagePath;
  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 13.0, vertical: 20),
      child: GestureDetector(
        onTap: onpressed,
        child: AnimatedContainer(
          padding: EdgeInsets.all(7),
          width: width,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[200],
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 10))
              ]),
          duration: Duration(milliseconds: 20),
          child: Image.asset(
            imagePath,
            color: color,
          ),
        ),
      ),
    );
  }
}
