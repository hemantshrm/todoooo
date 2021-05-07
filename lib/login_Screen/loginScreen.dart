import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'package:todoooo/component/auth_controller.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/mainScreen/MainScreen.dart';
import 'package:todoooo/signupScreen/signupScrenn.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AuthController authController = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController());
  AnimationController controller;
  Animation animation;
  var firebaseAuth = FirebaseAuth.instance;
  GetStorage userInfo = GetStorage();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = Tween<double>(begin: 20, end: 40).animate(controller);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Stack(children: [
              Container(
                child: Lottie.asset(
                  'images/bg.json',
                  fit: BoxFit.cover,
                  frameRate: FrameRate(60),
                ),
                decoration: BoxDecoration(
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
                  totalRepeatCount: 1,
                  text: ['To-Duh'],
                  textStyle: GoogleFonts.ubuntu(
                      color: AppColors.appTheme,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ListView(
                shrinkWrap: true,
                children: [
                  LoginFields(
                    hidetext: false,
                    heading: "Email",
                    icon: Icon(
                      FontAwesomeIcons.user,
                      size: 20,
                      color: AppColors.appTheme,
                    ),
                    color: AppColors.TextColour_light,
                    keyboard: TextInputType.emailAddress,
                    textEditingController: homeController.loginEmail,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  LoginFields(
                    hidetext: true,
                    heading: "Password",
                    icon: Icon(
                      FontAwesomeIcons.lock,
                      size: 20,
                      color: AppColors.appTheme,
                    ),
                    keyboard: TextInputType.visiblePassword,
                    textEditingController: homeController.loginPassword,
                    color: AppColors.TextColour_light,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedLoadingButton(
                    successColor: Colors.green,
                    color: AppColors.appTheme,
                    child: Text('Login',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    controller: homeController.btnController,
                    onPressed: () async {
                      try {
                        final newUser =
                            await firebaseAuth.signInWithEmailAndPassword(
                                email: homeController.loginEmail.text,
                                password: homeController.loginPassword.text);
                        if (newUser != null) {
                          homeController.btnController.success();
                          Get.toNamed(TodoScreen.id);
                          userInfo.write(
                              'email', homeController.loginEmail.text);
                        }
                      } on FirebaseAuthException catch (e) {
                        homeController.btnController.error();
                        if (e.code == 'user-not-found') {
                          homeController
                              .errorSnackbar('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          homeController.errorSnackbar(
                              'Wrong password provided for that user.');
                        }
                      } finally {
                        homeController.resetLoader();
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      child: Text(
                        "Sign Up",
                        style: designStyle.copyWith(
                            color: AppColors.appTheme, fontSize: 16),
                      ),
                      onTap: () {
                        Get.to(() => SignUpScreen(),
                            transition: Transition.downToUp);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthIcons extends StatelessWidget {
  AuthIcons({@required this.onpressed, this.imagePath, this.width});
  final Function onpressed;
  final String imagePath;
  final double width;

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
          ),
        ),
      ),
    );
  }
}

class LoginFields extends StatelessWidget {
  LoginFields(
      {this.icon,
      this.hintText,
      this.heading,
      this.suffixIcon,
      this.hidetext,
      this.onpress,
      this.textEditingController,
      this.keyboard,
      this.color});

  final Function onpress;
  final String hintText, heading;
  final Icon icon;
  final IconButton suffixIcon;
  final bool hidetext;
  final TextInputType keyboard;
  final TextEditingController textEditingController;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: AppColors.appTheme,
      ),
      child: TextFormField(
          onChanged: onpress,
          keyboardType: keyboard,
          cursorColor: AppColors.appTheme,
          obscureText: hidetext,
          textInputAction: TextInputAction.unspecified,
          maxLines: 1,
          controller: textEditingController,
          autofocus: false,
          style: GoogleFonts.ubuntu(color: color),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              labelText: heading,
              labelStyle: GoogleFonts.ubuntu(
                color: AppColors.appTheme,
                fontSize: 16,
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: AppColors.appTheme),
              ),
              prefixIcon: icon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              contentPadding: EdgeInsets.only(left: 2, bottom: 4),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.appTheme)),
              hintStyle: GoogleFonts.ubuntu(fontSize: 16))),
    );
  }
}
