import 'package:be_free_v1/Providers/AvatarProvider.dart';
import 'package:be_free_v1/Providers/CreateEventProvider.dart';
import 'package:be_free_v1/Providers/EventsGoingProvider.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/LikeProvider.dart';
import 'package:be_free_v1/Providers/ListUsersProvider.dart';
import 'package:be_free_v1/Providers/LoginEventOwnerProvider.dart';
import 'package:be_free_v1/Providers/LoginProvider.dart';
import 'package:be_free_v1/Providers/LikesReceivedProvider.dart';
import 'package:be_free_v1/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_v1/Providers/RegisterProvider.dart';
import 'package:be_free_v1/Providers/SearchEventProvider.dart';
import 'package:be_free_v1/Providers/SearchUserProvider.dart';
import 'package:be_free_v1/Providers/UpdateEventProvider.dart';
import 'package:be_free_v1/Providers/UpdateUserProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Providers/ProviderImage.dart';
import 'package:be_free_v1/Providers/YourEventsProvider.dart';
import 'package:be_free_v1/Screens/Splash/Splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/EventsStatusProvider.dart';
import 'Providers/MatchProvider.dart';
import 'Providers/MessagesProvider.dart';

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
        ChangeNotifierProvider(create: (context) => UpdateEventProvider()),
        ChangeNotifierProvider(create: (context) => MessagesProvider()),
        ChangeNotifierProvider(create: (context) => SearchUserProvider()),
        ChangeNotifierProvider(create: (context) => LikesReceivedProvider()),
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
      // routes: {"/login": (context) => LoginScreen()},
    );
  }
}
