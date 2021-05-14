import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoooo/constants.dart';
import 'package:todoooo/dashboard/dashboard.dart';
import 'package:todoooo/login_Screen/loginScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoooo/todoScreen/Todo_Screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GetStorage userInfo = GetStorage();
    var user = userInfo.read('email');
    return GetMaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.appTheme,
          accentColor: AppColors.App_COMPLIMENTARY,
          fontFamily: 'ubuntu',
          iconTheme: IconThemeData(color: AppColors.appTheme),
        ),
        initialRoute: user == null ? LoginScreen.id : Dashboard.id,
        routes: <String, WidgetBuilder>{
          TodoScreen.id: (context) => TodoScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          Dashboard.id: (context) => Dashboard(),
        });
  }
}
