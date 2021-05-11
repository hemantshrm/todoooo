import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoooo/chatScreen/views/user_chat_screen.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/todoScreen/Todo_Screen.dart';

import '../../constants.dart';

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
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppColors.appTheme,
        body: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Chat\'s',
                textScaleFactor: 2.3,
                style: designStyle.copyWith(fontWeight: FontWeight.w500),
              ),
            )),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: AppColors.APP_BG_COLOR_DARK,
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: users.snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        physics: BouncingScrollPhysics(),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          var name = document.data()['name'];
                          var userId = document.data()['userId'];

                          return Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    title: Text(
                                      name,
                                      style: designStyle.copyWith(fontSize: 18),
                                    ),
                                    leading: CircleAvatar(),
                                    onTap: () {
                                      Get.to(() => Chat(), arguments: userId);
                                    },
                                  )),
                            ],
                          );
                        }).toList(),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
