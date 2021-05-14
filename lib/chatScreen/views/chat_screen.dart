import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoooo/chatScreen/views/add_new_convo.dart';

import '../../constants.dart';

class ChatViewScreen extends StatelessWidget {
  ChatViewScreen();
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.appTheme,
          child: Icon(
            Icons.message_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() => NewConvo());
          },
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              // child: Text(
              //   'Chat\'s',
              //   textScaleFactor: 2.3,
              //   style: designStyle.copyWith(fontWeight: FontWeight.w500),
              // ),
            )),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    height: Get.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: AppColors.APP_BG_COLOR_DARK,
                    ),
                  ),
                  // StreamBuilder<QuerySnapshot>(
                  //     stream: users.snapshots(includeMetadataChanges: true),
                  //     builder: (BuildContext context,
                  //         AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if (snapshot.hasError) {
                  //         return Text('Something went wrong');
                  //       }
                  //
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Center(child: CircularProgressIndicator());
                  //       }
                  //       return ListView(
                  //         shrinkWrap: true,
                  //         physics: BouncingScrollPhysics(),
                  //         children: snapshot.data.docs
                  //             .map((DocumentSnapshot document) {
                  //           var name = document.data()['name'];
                  //           var userId = document.data()['userId'];

                  //       return Container(
                  //         alignment: Alignment.topCenter,
                  //         padding: EdgeInsets.symmetric(vertical: 6),
                  //         child: ListTile(
                  //           title: Text(
                  //             name,
                  //             style: designStyle.copyWith(fontSize: 18),
                  //           ),
                  //           leading: CircleAvatar(),
                  //           onTap: () {
                  //             Get.to(
                  //               () => Chat(),
                  //               arguments: [userId, name],
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     }).toList(),
                  //   );
                  // })
                ],
              ),
            ),
          ],
        ));
  }
}
