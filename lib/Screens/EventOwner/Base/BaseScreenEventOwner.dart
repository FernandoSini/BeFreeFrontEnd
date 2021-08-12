import 'dart:async';

import 'package:be_free_v1/Models/EventOwner.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventOwnerProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/EventOwner/CreateEvent/CreateEventScreen.dart';
import 'package:be_free_v1/Screens/EventOwner/EventOwnerHome/EventOwnerHome.dart';
import 'package:be_free_v1/Screens/EventOwner/Profile/YourProfileScreenEventOwner.dart';
import 'package:be_free_v1/Screens/Matches/MatchesScreen.dart';
import 'package:be_free_v1/Screens/Events/EventsScreen.dart';
import 'package:be_free_v1/Screens/Home/HomeScreen.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Screens/Profile/YourProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as universal;

class BaseScreenEventOwner extends StatefulWidget {
  BaseScreenEventOwner({this.eventOwner});
  EventOwner? eventOwner;

  @override
  _BaseScreenEventOwnerState createState() => _BaseScreenEventOwnerState();
}

class _BaseScreenEventOwnerState extends State<BaseScreenEventOwner> {
  int page = 0;
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<EventOwnerProvider>(context, listen: false)
            .setEventOwner(widget.eventOwner!);
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      var eventOwnerToken = await storage.read(key: "event_owner_token");
      if (eventOwnerToken != null) {
        if (JwtDecoder.isExpired(eventOwnerToken)) {
          await storage.deleteAll();
          print("token expirou");
          Timer(
            Duration(seconds: 3),
            () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          );
        }
      }
    } else {
      if (JwtDecoder.isExpired(
          universal.window.localStorage["event_owner_token"]!)) {
        universal.window.localStorage.clear();
        print("token expirou");
        Timer(
          Duration(seconds: 5),
          () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
            );
          },
        );
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      EventOwnerHome(
        eventOwner: widget.eventOwner,
      ),
      // EventsScreen(),
      YourProfileScreenEventOwner(ownerData: widget.eventOwner!)
    ];
    return Scaffold(
      body: screens[page],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: Color(0xFF9a00e6),
        tooltip: "Add photos or Images to your profile",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateEventScreen(widget.eventOwner!),
              fullscreenDialog: true,
              maintainState: true,
            ),
          );
        },
      ),
      bottomNavigationBar: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? BottomAppBar(
              // color: Colors.transparent,
              notchMargin: 2,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              shape: CircularNotchedRectangle(),
              child: CupertinoTabBar(
                backgroundColor: Colors.white,
                activeColor: Color(0xFF9a00e6),
                currentIndex: page,
                onTap: (index) {
                  setState(() {
                    page = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nightlife),
                    activeIcon: Icon(Icons.nightlife, color: Colors.pink),
                    label: "Your Events",
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.nightlife),
                  //   label: "Events",
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.whatshot_outlined),
                  //   label: "Matches",
                  // ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: EdgeInsets.only(top: 7),
                      child: CircleAvatar(
                        backgroundImage:
                            widget.eventOwner?.avatarProfile != null
                                ? NetworkImage(
                                    "${widget.eventOwner!.avatarProfile!.url}")
                                : AssetImage("assets/avatars/avatar2.png")
                                    as ImageProvider,
                      ),
                    ),
                    label: "",
                  ),
                ],
              ),
            )
          : BottomAppBar(
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              notchMargin: 2,
              shape: CircularNotchedRectangle(),
              child: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                currentIndex: page,
                selectedItemColor: Color(0xFF9a00e6),
                onTap: (index) {
                  setState(() {
                    page = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nightlife),
                    activeIcon: Icon(
                      Icons.nightlife,
                      color: Colors.pink,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: EdgeInsets.only(top: 7),
                      child: CircleAvatar(
                        backgroundImage:
                            widget.eventOwner?.avatarProfile != null
                                ? NetworkImage(
                                    "${widget.eventOwner!.avatarProfile!.url}")
                                : AssetImage("assets/avatars/avatar2.png")
                                    as ImageProvider,
                      ),
                    ),
                    label: "",
                  ),
                ],
              ),
            ),
    );
  }
}
