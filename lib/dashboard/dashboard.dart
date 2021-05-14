import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoooo/chatScreen/views/chat_screen.dart';
import 'package:todoooo/constants.dart';
import 'package:todoooo/login_Screen/loginScreen.dart';
import 'package:todoooo/todoScreen/Todo_Screen.dart';

class Dashboard extends StatefulWidget {
  static String id = 'dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

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

class _DashboardState extends State<Dashboard> {
  GetStorage userInfo = GetStorage();
  var firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: AppDrawer(
            firebaseAuth: firebaseAuth,
            userInfo: userInfo,
          ),
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () async {
                        firebaseAuth.signOut();
                        userInfo.remove('email');
                        Get.offAndToNamed(LoginScreen.id);
                      },
                    )
                  ],
                  title: Text("Good ${greeting()}",
                      style: designStyle.copyWith(fontSize: 18)),
                  pinned: true,
                  floating: true,
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    labelStyle: designStyle.copyWith(fontSize: 18),
                    isScrollable: true,
                    tabs: [Tab(text: "Todo"), Tab(text: "Chat")],
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                TodoScreen(),
                ChatViewScreen(),
              ],
            ),
          ),
        ));
  }
}
// call toh kro
