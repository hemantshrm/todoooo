import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoooo/constants.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/login_Screen/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final HomeController controller = Get.put(HomeController());
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  final _firebase = FirebaseAuth.instance;
  User loggedInUser;
  bool isMe;

  void getCurrentUser() async {
    try {
      final person = await _firebase.currentUser;
      if (person != null) {
        loggedInUser = person;
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Himanshu'),
          backgroundColor: AppColors.appTheme,
          elevation: 6,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.phone),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: messages
                        .orderBy('timeStamp', descending: true)
                        .snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        reverse: true,
                        physics: BouncingScrollPhysics(
                            parent: NeverScrollableScrollPhysics()),
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          var text = document.data()['text'];
                          var sender = document.data()['sender'];
                          var time = document.data()['timeStamp'];
                          final currentUser = loggedInUser.email;

                          isMe = currentUser == sender;

                          return Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Material(
                                  elevation: 6,
                                  color: isMe
                                      ? AppColors.appTheme
                                      : Colors.blueGrey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: isMe
                                        ? Radius.circular(30)
                                        : Radius.circular(0),
                                    topRight: isMe
                                        ? Radius.circular(0)
                                        : Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Text(
                                      text,
                                      style: GoogleFonts.ubuntu(
                                          color: AppColors.TextColour_light),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.TEXTCOLOR_DARK,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(2),
                child: LoginFields(
                  hidetext: false,
                  color: AppColors.TextColour_light,
                  hintText: " Write your message",
                  textEditingController: controller.chatting,
                  suffixIcon: IconButton(
                    icon: Icon(FontAwesomeIcons.arrowCircleRight),
                    onPressed: () {
                      controller.chatting.text.isEmpty
                          ? null
                          : messages.add({
                              'text': controller.chatting.text,
                              'sender': loggedInUser.email,
                              'timeStamp': DateTime.now()
                            });
                      controller.chatting.clear();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
