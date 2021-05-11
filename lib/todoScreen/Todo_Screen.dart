import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:todoooo/chatScreen/views/chat_screen.dart';
import 'package:todoooo/login_Screen/home_controller.dart';
import 'package:todoooo/login_Screen/loginScreen.dart';

import '../constants.dart';

class TodoScreen extends StatefulWidget {
  static String id = 'main_screen';
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> with TickerProviderStateMixin {
  TextEditingController todoController = TextEditingController();
  HomeController _controller = Get.put(HomeController());
  GetStorage userInfo = GetStorage();
  var firebaseAuth = FirebaseAuth.instance;
  CollectionReference todoServer =
      FirebaseFirestore.instance.collection('todos');
  bool status = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        SystemNavigator.pop();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              child: FlutterSwitch(
                activeColor: Colors.white,
                inactiveColor: Color(0xff0D1117),
                activeText: "Light",
                inactiveText: "Dark",
                activeIcon: Icon(
                  Icons.wb_sunny,
                  color: Colors.orangeAccent,
                ),
                activeToggleColor: AppColors.APP_BG_COLOR_light,
                activeTextColor: Colors.black,
                inactiveIcon: Icon(
                  FontAwesomeIcons.solidMoon,
                  color: Color(0xffF8E3A1),
                ),
                inactiveToggleColor: Color(0xff21262D),
                width: 60.0,
                height: 30.0,
                valueFontSize: 10.0,
                toggleSize: 20.0,
                value: status,
                borderRadius: 30.0,
                padding: 5.0,
                showOnOff: true,
                onToggle: (val) {
                  setState(() {
                    status = val;
                  });
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(firebaseAuth: firebaseAuth, userInfo: userInfo),
        backgroundColor:
            status ? AppColors.APP_BG_COLOR_light : AppColors.APP_BG_COLOR_DARK,
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TypewriterAnimatedTextKit(
                        speed: Duration(milliseconds: 200),
                        repeatForever: false,
                        totalRepeatCount: 1,
                        text: ['Tasks'],
                        textStyle: GoogleFonts.ubuntu(
                            color: AppColors.appTheme,
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 7,
              child: StreamBuilder<QuerySnapshot>(
                  stream: todoServer
                      .doc(firebaseAuth.currentUser.uid)
                      .collection('list')
                      .orderBy('timeStamp')
                      .snapshots(includeMetadataChanges: true),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    try {
                      if (snapshot.data.docs.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/noTask.png'),
                            Text(
                              'No task on the horizon !',
                              style: designStyle.copyWith(
                                  fontSize: 20,
                                  color: status
                                      ? AppColors.TEXTCOLOR_DARK
                                      : AppColors.TextColour_light),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Add a task or enjoy your day off.',
                              style: designStyle.copyWith(
                                  fontSize: 13,
                                  color:
                                      status ? Colors.black38 : Colors.white38),
                            )
                          ],
                        );
                      }
                    } catch (e) {
                      print(e);
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        var tasks = document.data()['title'];
                        var isCompleted = document.data()['isCompleted'];
                        var time = DateTime.fromMillisecondsSinceEpoch(
                            document.data()['timeStamp'],
                            isUtc: true);

                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actions: [
                              IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.transparent,
                                  icon: Icons.delete,
                                  foregroundColor: AppColors.App_COMPLIMENTARY,
                                  onTap: () => _controller.delete(document.id)),
                            ],
                            secondaryActions: [
                              IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.transparent,
                                  icon: Icons.delete,
                                  foregroundColor: AppColors.App_COMPLIMENTARY,
                                  onTap: () => _controller.delete(document.id))
                            ],
                            child: Material(
                              color: status
                                  ? Colors.white
                                  : AppColors.APP_BG_COLOR_DARK_comp,
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                subtitle: Text(
                                  time.toString(),
                                  softWrap: true,
                                  style: GoogleFonts.ubuntu(
                                      fontSize: 10,
                                      color: AppColors.TEXTCOLOR_DARK),
                                ),
                                title: Text(
                                  tasks,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 17,
                                    color: isCompleted
                                        ? status
                                            ? Color(0xff54556E)
                                            : Color(0xff54556E)
                                        : status
                                            ? AppColors.TEXTCOLOR_DARK
                                            : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                trailing: CircularCheckBox(
                                    value: isCompleted,
                                    checkColor: Colors.white,
                                    activeColor: AppColors.appTheme,
                                    inactiveColor: AppColors.App_COMPLIMENTARY,
                                    onChanged: (val) => this.setState(() {
                                          isCompleted = !isCompleted;
                                          todoServer
                                              .doc(firebaseAuth.currentUser.uid)
                                              .collection('list')
                                              .doc(document.id)
                                              .update(
                                                  {'isCompleted': isCompleted});
                                        })),
                                onTap: () {
                                  this.setState(() {
                                    isCompleted = !isCompleted;
                                    todoServer
                                        .doc(firebaseAuth.currentUser.uid)
                                        .collection('list')
                                        .doc(document.id)
                                        .update({'isCompleted': isCompleted});
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: status ? Colors.white : AppColors.APP_BG_COLOR_DARK_comp,
                borderRadius: BorderRadius.circular(30),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: TextField(
                      autofocus: false,
                      style: GoogleFonts.ubuntu(
                          color:
                              status ? AppColors.TEXTCOLOR_DARK : Colors.white),
                      controller: todoController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(FontAwesomeIcons.arrowCircleUp),
                            onPressed: () {
                              todoController.text.isEmpty
                                  ? null
                                  : todoServer
                                      .doc(firebaseAuth.currentUser.uid)
                                      .collection('list')
                                      .add({
                                      'userid': firebaseAuth.currentUser.uid,
                                      'title': todoController.text,
                                      'isCompleted': false,
                                      'timeStamp': DateTime.now()
                                          .toUtc()
                                          .millisecondsSinceEpoch
                                    });
                              todoController.clear();
                            },
                          ),
                          border: InputBorder.none,
                          hintText: 'Write new task',
                          focusedBorder: InputBorder.none,
                          hintStyle: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: status
                                  ? AppColors.APP_BG_COLOR_DARK_comp
                                  : Colors.white))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDrawer extends GetView<HomeController> {
  AppDrawer({
    @required this.firebaseAuth,
    @required this.userInfo,
  });

  final FirebaseAuth firebaseAuth;
  final GetStorage userInfo;
  HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.appTheme,
                radius: 50,
              ),
              Spacer(),
              Text(
                firebaseAuth.currentUser.email,
                style: designStyle.copyWith(
                    fontWeight: FontWeight.w500, fontSize: 19),
              )
            ],
          )),
          CustomTiles(Icon(Icons.message), 'Chat Screen', () {
            Get.to(() => ChatViewScreen());
          }),
          CustomTiles(Icon(FontAwesomeIcons.featherAlt), 'Todo Screen', () {
            Get.offAndToNamed(TodoScreen.id);
          }),
          CustomTiles(Icon(FontAwesomeIcons.lock), 'Change Password', () {
            firebaseAuth.sendPasswordResetEmail(email: userInfo.read('email'));
          }),
          CustomTiles(
            Icon(FontAwesomeIcons.signOutAlt),
            'Logout',
            () async {
              firebaseAuth.signOut();
              userInfo.remove('email');
              Get.offAndToNamed(LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}

class CustomTiles extends StatelessWidget {
  CustomTiles(this.icon, this.title, this.onPress);

  final String title;
  final Icon icon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
          leading: icon,
          title: Text(title, style: designStyle.copyWith(fontSize: 18)),
          onTap: onPress),
    );
  }
}
