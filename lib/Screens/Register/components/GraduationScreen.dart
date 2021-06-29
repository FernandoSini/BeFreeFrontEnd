// import 'dart:math';
//
// import 'package:be_free_front/Models/Gender.dart';
// import 'package:be_free_front/Providers/RegisterProvider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'PasswordScreen.dart';
//
// class GraduationScreen extends StatefulWidget {
//   @override
//   _GraduationScreenState createState() => _GraduationScreenState();
// }
//
// class _GraduationScreenState extends State<GraduationScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           iconTheme: IconThemeData(color: Colors.black),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Consumer<RegisterProvider>(
//             builder: (_, registerProvider, __) {
//               return Text(
//                 "BeFree",
//                 style: TextStyle(
//                   fontFamily: "Segoe",
//                   color: Color(0xFF9a00e6),
//                   fontSize: (defaultTargetPlatform == TargetPlatform.android ||
//                           defaultTargetPlatform == TargetPlatform.iOS)
//                       ? 30
//                       : 50,
//                   fontWeight: FontWeight.bold,
//                 ),
//               );
//             },
//           ),
//           centerTitle: true),
//       body: Container(
//         child: ListView(
//           physics: NeverScrollableScrollPhysics(),
//           children: [
//             const SizedBox(
//               height: 50,
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: Text(
//                 "Select your graduation(if you have): ",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: Text(
//                 "Or",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               margin: EdgeInsets.only(left: 50, right: 50),
//               height: 55,
//               child: Consumer<RegisterProvider>(
//                   builder: (_, registerProvider, __) {
//                 return ElevatedButton(
//                   child: Text(
//                     "Skip this step",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     primary: Color(0xff9a00e6),
//                     elevation: 5,
//                     // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   onPressed: null ??
//                       () {
//                         // registerProvider.setYourGraduation(null);
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => PasswordScreen(),
//                           ),
//                         );
//                       },
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
