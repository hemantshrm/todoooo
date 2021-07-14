import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
  var chattingUser = Get.arguments[1];
  var chattingUserID = Get.arguments[0];

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

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appTheme,
      appBar: AppBar(
        title: Text(chattingUser),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.APP_BG_COLOR_DARK,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: messages
                      .doc(getConversationID(
                          _firebase.currentUser.uid, chattingUserID))
                      .collection('chat')
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
                        var time = DateTime.fromMillisecondsSinceEpoch(
                          document.data()['timeStamp'],
                          isUtc: true,
                        );

                        final currentUser = loggedInUser.email;
                        isMe = currentUser == sender;

                        return Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              isMe ? '' : chattingUser,
                              style: designStyle.copyWith(fontSize: 10),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                elevation: 6,
                                color:
                                    isMe ? AppColors.appTheme : Colors.blueGrey,
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
                                  child: Wrap(
                                    spacing: 40,
                                    children: [
                                      Text(
                                        text,
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 15,
                                            color: AppColors.TextColour_light),
                                      ),
                                      Text(
                                        controller
                                            .getTime_forChat(time.toString()),
                                        style: GoogleFonts.ubuntu(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ),
                                    ],
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
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: AppColors.TEXTCOLOR_DARK,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: LoginFields(
                  hidetext: false,
                  color: AppColors.TextColour_light,
                  hintText: "Type your message...",
                  textEditingController: controller.chatting,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded),
                    onPressed: () {
                      controller.chatting.text.isEmpty
                          ? null
                          : messages
                              .doc(getConversationID(
                                  _firebase.currentUser.uid, chattingUserID))
                              .collection('chat')
                              .add({
                              'text': controller.chatting.text.capitalizeFirst,
                              'sender': loggedInUser.email,
                              'read': false,
                              'idTo': chattingUserID,
                              'senderID': _firebase.currentUser.uid,
                              'timeStamp':
                                  DateTime.now().toUtc().millisecondsSinceEpoch
                            });
                      controller.chatting.clear();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
