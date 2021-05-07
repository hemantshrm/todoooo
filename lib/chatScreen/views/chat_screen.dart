import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoooo/chatScreen/views/user_chat_screen.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/mainScreen/MainScreen.dart';

class ChatViewScreen extends GetView<HomeController> {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning,';
    }
    if (hour < 17) {
      return 'Afternoon,';
    }
    return 'Evening,';
  }

  // Center(
  //   child: Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text("Good ", style: designStyle),
  //       Text(greeting(), style: designStyle),
  //     ],
  //   ),
  // ),
  GetStorage userInfo = GetStorage();
  var firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: AppDrawer(firebaseAuth: firebaseAuth, userInfo: userInfo),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Chats',
                  style: GoogleFonts.ubuntu(fontSize: 28, letterSpacing: 1),
                ),
                SizedBox(
                  height: Get.height / 9,
                ),
                ListView.separated(
                  separatorBuilder: (BuildContext context, index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(2),
                      leading: CircleAvatar(),
                      title: Text(
                        'Himanshu',
                        style:
                            GoogleFonts.ubuntu(fontSize: 16, letterSpacing: 1),
                      ),
                      subtitle: Text('the last text'),
                      trailing: Text('2m ago'),
                      onTap: () {
                        Get.to(() => Chat());
                      },
                    );
                  },
                  shrinkWrap: true,
                  itemCount: 5,
                )
              ],
            ),
          )),
    );
  }
}
