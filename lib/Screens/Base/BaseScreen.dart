import 'dart:async';

import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/UserProvider.dart';
import 'package:be_free_front/Screens/Matches/MatchesScreen.dart';
import 'package:be_free_front/Screens/Events/EventsScreen.dart';
import 'package:be_free_front/Screens/Home/HomeScreen.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:be_free_front/Screens/Profile/YourProfileScreen.dart';
import 'package:be_free_front/Screens/Profile/components/PhotosScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as universal;

class BaseScreen extends StatefulWidget {
  BaseScreen({this.userData});
  User? userData;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int page = 0;
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false)
            .setUser(widget.userData);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(
        userData: widget.userData!,
      ),
      EventsScreen(user: widget.userData!),
      MatchesScreen(
        user: widget.userData!,
      ),
      YourProfileScreen(
        userData: widget.userData!,
      ),
    ];
    return Scaffold(
      extendBody: true,
      body: screens[page],
      bottomNavigationBar: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? BottomAppBar(
              color: Colors.white,
              notchMargin: 2,
              elevation: 0,
              shape: CircularNotchedRectangle(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
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
                    icon: Icon(Icons.favorite),
                    activeIcon: Icon(
                      Icons.favorite,
                      color: Color(0xffedc967),
                    ),
                    // label: "Find",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nightlife),
                    activeIcon: Icon(
                      Icons.nightlife,
                      color: Colors.blue,
                    ),
                    // label: "Events",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.whatshot_outlined),
                    activeIcon: Icon(
                      Icons.whatshot_outlined,
                      color: Colors.pinkAccent[400],
                    ),
                    // label: "Matches",
                  ),
                  BottomNavigationBarItem(
                    tooltip: null,
                    icon: Container(
                      // margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircleAvatar(
                          backgroundImage:
                              widget.userData?.avatarProfile != null
                                  ? NetworkImage(
                                      "${widget.userData!.avatarProfile!.url}")
                                  : AssetImage("assets/avatars/avatar2.png")
                                      as ImageProvider,
                          radius: 15,
                        ),
                      ),
                    ),
                    label: "",
                  ),
                ],
              ),
            )
          : BottomAppBar(
              elevation: 0,
              notchMargin: 5,
              shape: CircularNotchedRectangle(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(30),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
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
                        icon: Icon(Icons.favorite),
                        activeIcon: Icon(
                          Icons.favorite,
                          color: Colors.pink,
                        ),
                        label: "Find",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.nightlife),
                        activeIcon: Icon(Icons.nightlife),
                        label: "Events",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.whatshot_outlined),
                        label: "Matches",
                      ),
                      BottomNavigationBarItem(
                        tooltip: null,
                        icon: Container(
                          padding: EdgeInsets.only(top: 7),
                          child: CircleAvatar(
                            backgroundImage: widget.userData?.avatarProfile !=
                                    null
                                ? NetworkImage(
                                    "${widget.userData!.avatarProfile!.url}")
                                : AssetImage("assets/avatars/avatar2.png")
                                    as ImageProvider,
                          ),
                        ),
                        label: "",
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        backgroundColor: Color(0xFF9a00e6),
        tooltip: "Add photos or Images to your profile",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PhotosScreen(user: widget.userData!),
              fullscreenDialog: true,
              maintainState: true,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
