// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:todoooo/login_Screen/loginScreen.dart';
//
// class SplashScreen extends StatefulWidget {
//   static String id = 'splash_screen';
//   final Color backgroundColor = Colors.black12;
//   final TextStyle styleTextUnderTheLoader = TextStyle(
//       fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   final splashDelay = 1;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadWidget();
//   }
//
//   _loadWidget() async {
//     var _duration = Duration(seconds: splashDelay);
//     return Timer(_duration, navigationPage);
//   }
//
//   void navigationPage() {
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black12,
//       body: InkWell(
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   flex: 6,
//                   child: Container(
//                       child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(top: 70.0),
//                         child: Text(
//                           'To-Duh',
//                           style: TextStyle(
//                               fontSize: 80,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff2EBDD8)),
//                         ),
//                       ),
//                     ],
//                   )),
//                 ),
//                 Expanded(
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         height: 10,
//                       ),
//                       Text(
//                         'By Hemant',
//                         style: TextStyle(
//                             fontSize: 20,
//                             letterSpacing: 2,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xff2EBDD8)),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
