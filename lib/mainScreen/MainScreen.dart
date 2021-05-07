import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  GetStorage userInfo = GetStorage();
  var firebaseAuth = FirebaseAuth.instance;
  CollectionReference todoServer =
      FirebaseFirestore.instance.collection('todos');

  AnimationController controller;

  // getUserAuthBiometric() async {
  //   userCred = await userInfo.read('email') ?? null;
  //   if (userCred != null) {
  //     if (!userCred.checkBiometric) {
  //       showAlertDialogBiometric(context, userCred.checkBiometric,
  //           okPressed: (colorHandle) {
  //         this.setState(() {
  //           userCred.checkBiometric = true;
  //         });
  //         _authenticate(userCred);
  //       }, cancelPressed: (colorHandle) {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       }, disabledPressed: () async {
  //         this.setState(() {
  //           userCred.checkBiometric = false;
  //         });
  //
  //         userCred = await widget._userInfo.saveCredentials(userCred);
  //         Navigator.of(context, rootNavigator: true).pop();
  //       });
  //     }
  //   }
  // }
  Future<void> delete(String id) {
    return todoServer.doc(id).delete().then((value) => print("Deleted"));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   controller = AnimationController(
  //     duration: Duration(seconds: 3),
  //     vsync: this,
  //   );
  //   controller.addListener(() {
  //     setState(() {});
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // ignore: missing_return
        SystemNavigator.pop();
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          drawer: AppDrawer(firebaseAuth: firebaseAuth, userInfo: userInfo),
          backgroundColor: AppColors.APP_BG_COLOR_light,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      Container(
                        width: Get.width,
                        height: Get.height,
                        child: Lottie.asset('images/bg.json',
                            fit: BoxFit.cover,
                            frameRate: FrameRate(60),
                            controller: controller),
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
                          text: ['Tasks'],
                          textStyle: GoogleFonts.ubuntu(
                              color: AppColors.appTheme,
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 7,
                child: StreamBuilder<QuerySnapshot>(
                    stream: todoServer
                        .orderBy('timeStamp')
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
                                    foregroundColor:
                                        AppColors.App_COMPLIMENTARY,
                                    onTap: () => delete(document.id)),
                              ],
                              secondaryActions: [
                                IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.transparent,
                                    icon: Icons.delete,
                                    foregroundColor:
                                        AppColors.App_COMPLIMENTARY,
                                    onTap: () => delete(document.id))
                              ],
                              child: Material(
                                color: Colors.white,
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
                                          ? Color(0xffB7BABF)
                                          : AppColors.TEXTCOLOR_DARK,
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
                                      inactiveColor:
                                          AppColors.App_COMPLIMENTARY,
                                      onChanged: (val) => this.setState(() {
                                            isCompleted = !isCompleted;
                                            todoServer.doc(document.id).update(
                                                {'isCompleted': isCompleted});
                                          })),
                                  onTap: () {
                                    this.setState(() {
                                      isCompleted = !isCompleted;
                                      todoServer
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: TextField(
                        style:
                            GoogleFonts.ubuntu(color: AppColors.TEXTCOLOR_DARK),
                        controller: todoController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(FontAwesomeIcons.arrowCircleUp),
                              onPressed: () {
                                todoController.text.isEmpty
                                    ? null
                                    : todoServer.add({
                                        'userid': firebaseAuth.currentUser.uid,
                                        'title': todoController.text,
                                        'isCompleted': false,
                                        'timeStamp': DateTime.now()
                                            .toUtc()
                                            .millisecondsSinceEpoch
                                      });
                                todoController.clear();
                                Get.offAndToNamed(TodoScreen.id);
                              },
                            ),
                            border: InputBorder.none,
                            hintText: 'Write new task',
                            focusedBorder: InputBorder.none,
                            hintStyle: GoogleFonts.ubuntu(
                                fontSize: 16,
                                color: AppColors.TEXTCOLOR_DARK))),
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
            _controller.getUserName();
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
