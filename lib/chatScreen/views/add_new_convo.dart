import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoooo/chatScreen/views/user_chat_screen.dart';
import 'package:todoooo/constants.dart';

class NewConvo extends StatelessWidget {
  GetStorage userInfo = GetStorage();
  var firebaseAuth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool myself;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        elevation: 0,
      ),
      backgroundColor: AppColors.appTheme,
      body: Container(
        height: Get.height,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.APP_BG_COLOR_DARK,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(includeMetadataChanges: true),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  var name = document.data()['name'];
                  var userId = document.data()['userId'];
                  final currentUserId = firebaseAuth.currentUser.uid;
                  myself = currentUserId == userId;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        myself
                            ? Container()
                            : ListTile(
                                title: Text(
                                  name,
                                  style: designStyle.copyWith(fontSize: 18),
                                ),
                                leading: CircleAvatar(
                                  maxRadius: 25,
                                ),
                                onTap: () {
                                  Get.to(
                                    () => Chat(),
                                    arguments: [userId, name],
                                  );
                                },
                              ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
