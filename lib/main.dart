import 'package:todoooo/login_Screen/loginScreen.dart';
import 'package:todoooo/mainScreen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'To-do',
        initialRoute: LoginScreen.id,
        routes: <String, WidgetBuilder>{
          // SplashScreen.id: (context) => SplashScreen(),
          MainScreen.id: (context) => MainScreen(),
          LoginScreen.id: (context) => LoginScreen(),
        });
  }
}
