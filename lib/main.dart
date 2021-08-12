import 'package:be_free_v1/Providers/AvatarProvider.dart';
import 'package:be_free_v1/Providers/CreateEventProvider.dart';
import 'package:be_free_v1/Providers/EventOwnerProvider.dart';
import 'package:be_free_v1/Providers/EventsGoingProvider.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/LikeProvider.dart';
import 'package:be_free_v1/Providers/ListUsersProvider.dart';
import 'package:be_free_v1/Providers/LoginEventOwnerProvider.dart';
import 'package:be_free_v1/Providers/LoginProvider.dart';
import 'package:be_free_v1/Providers/MatchProvider.dart';
import 'package:be_free_v1/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_v1/Providers/RegisterProvider.dart';
import 'package:be_free_v1/Providers/SearchEventProvider.dart';
import 'package:be_free_v1/Providers/SearchUserProvider.dart';
import 'package:be_free_v1/Providers/UpdateEventOwnerProvider.dart';
import 'package:be_free_v1/Providers/UpdateUserProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Providers/ProviderImage.dart';
import 'package:be_free_v1/Providers/YourEventsProvider.dart';
import 'package:be_free_v1/Screens/Splash/Splash.dart';
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
        ChangeNotifierProvider(create: (context) => SearchUserProvider()),
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
