import 'dart:io';

import 'package:be_free_front/Providers/EventOwnerProvider.dart';
import 'package:be_free_front/Providers/EventsGoingProvider.dart';
import 'package:be_free_front/Providers/EventsProvider.dart';
import 'package:be_free_front/Providers/ListUsersProvider.dart';
import 'package:be_free_front/Providers/LoginEventOwnerProvider.dart';
import 'package:be_free_front/Providers/LoginProvider.dart';
import 'package:be_free_front/Providers/MatchProvider.dart';
import 'package:be_free_front/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:be_free_front/Providers/UserProvider.dart';
import 'package:be_free_front/Screens/Splash/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as universal;

import 'Providers/EventsStatusProvider.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ListUsersProvider()),
        ChangeNotifierProvider(
            create: (context) => RegisterEventOwnerProvider()),
        ChangeNotifierProvider(create: (context) => LoginEventOwnerProvider()),
        ChangeNotifierProvider(create: (context) => EventOwnerProvider()),
        ChangeNotifierProvider(create: (context) => MatchProvider()),
        ChangeNotifierProvider(create: (context) => EventsProvider()),
        ChangeNotifierProvider(create: (context) => EventsStatusProvider()),
        ChangeNotifierProvider(create: (context) => EventsGoingProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeFree',
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
