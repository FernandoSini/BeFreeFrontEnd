import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Events/EventsScreen.dart';
import 'package:be_free_front/Screens/Home/HomeScreen.dart';
import 'package:be_free_front/Screens/Profile/EditProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({this.userData});
  User? userData;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(
        userData: widget.userData,
      ),
      EventsScreen(),
      EditProfile(
        userData: widget.userData,
      ),
    ];
    return Scaffold(
      body: screens[page],
      bottomNavigationBar: (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)
          ? BottomAppBar(
              color: Colors.white,
              notchMargin: 2,
              elevation: 0,
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
                    icon: Icon(Icons.favorite),
                    label: "find",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events_outlined),
                    label: "",
                  ),
                ],
              ),
            )
          : BottomAppBar(
              elevation: 0,
              shape: CircularNotchedRectangle(),
              child: BottomNavigationBar(
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
                    label: "maconha",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events_outlined),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: CircleAvatar(
                      backgroundImage: widget.userData?.avatar != null
                          ? NetworkImage("${widget.userData?.avatar}")
                          : AssetImage("assets/avatars/avatar2.png")
                              as ImageProvider,
                    ),
                    label: "",
                  ),
                ],
              ),
            ),
    );
  }
}
