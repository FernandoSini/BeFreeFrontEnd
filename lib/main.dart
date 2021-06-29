import 'package:be_free_front/Providers/AvatarProvider.dart';
import 'package:be_free_front/Providers/CreateEventProvider.dart';
import 'package:be_free_front/Providers/EventOwnerProvider.dart';
import 'package:be_free_front/Providers/EventsGoingProvider.dart';
import 'package:be_free_front/Providers/EventsProvider.dart';
import 'package:be_free_front/Providers/LikeProvider.dart';
import 'package:be_free_front/Providers/ListUsersProvider.dart';
import 'package:be_free_front/Providers/LoginEventOwnerProvider.dart';
import 'package:be_free_front/Providers/LoginProvider.dart';
import 'package:be_free_front/Providers/MatchProvider.dart';
import 'package:be_free_front/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:be_free_front/Providers/SearchEventProvider.dart';
import 'package:be_free_front/Providers/UpdateEventOwnerProvider.dart';
import 'package:be_free_front/Providers/UpdateUserProvider.dart';
import 'package:be_free_front/Providers/UserProvider.dart';
import 'package:be_free_front/Providers/ProviderImage.dart';
import 'package:be_free_front/Providers/YourEventsProvider.dart';
import 'package:be_free_front/Screens/Splash/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'Providers/EventOwnerAvatarProvider.dart';
import 'Providers/EventsStatusProvider.dart';
import 'Providers/MessagesProvider.dart';
import 'Screens/Login/LoginScreen.dart';

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
        ChangeNotifierProvider(create: (context) => ProviderImage()),
        ChangeNotifierProvider(create: (context) => YourEventsProvider()),
        ChangeNotifierProvider(create: (context) => CreateEventProvider()),
        ChangeNotifierProvider(create: (context) => UpdateUserProvider()),
        ChangeNotifierProvider(create: (context) => SearchEventProvider()),
        ChangeNotifierProvider(create: (context) => LikeProvider()),
        ChangeNotifierProvider(create: (context) => AvatarProvider()),
        ChangeNotifierProvider(create: (context) => EventOwnerAvatarProvider()),
        ChangeNotifierProvider(create: (context) => UpdateEventOwnerProvider()),
        ChangeNotifierProvider(create: (context) => MessagesProvider()),
      ],
      // child: DevicePreview(
      //   builder: (_) => MyApp(),
      // ),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeFree',
      debugShowCheckedModeBanner: false,
      // builder: DevicePreview.appBuilder,
      // locale: DevicePreview.locale(context),
      home: Splash(),
      routes: {
        "/login": (context) => LoginScreen()
      },
    );
  }
}
