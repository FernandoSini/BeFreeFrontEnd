import 'dart:async';

import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Matches/MatchesScreen.dart';
import 'package:be_free_front/Screens/Events/EventsScreen.dart';
import 'package:be_free_front/Screens/Home/HomeScreen.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:be_free_front/Screens/Profile/YourProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
  void didChangeDependencies() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      var token = await storage.read(key: "token");

      if (token != null) {
        if (JwtDecoder.isExpired(token)) {
          await storage.deleteAll();
          print("token expirou");
          
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
           
        }
      }
    } else {
      if (JwtDecoder.isExpired(universal.window.localStorage["token"]!)) {
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
      HomeScreen(
        userData: widget.userData,
      ),
      EventsScreen(),
      MatchesScreen(user: widget.userData,),
      YourProfileScreen(
        userData: widget.userData,
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
                    activeIcon: Icon(Icons.favorite, color: Colors.pink),
                    label: "Find",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nightlife),
                    label: "Events",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.whatshot_outlined),
                    label: "Matches",
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: EdgeInsets.only(top: 7),
                      child: CircleAvatar(
                        backgroundImage: widget.userData?.avatar != null
                            ? NetworkImage("${widget.userData?.avatar}")
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
                        icon: Container(
                          padding: EdgeInsets.only(top: 7),
                          child: CircleAvatar(
                            backgroundImage: widget.userData?.avatar != null
                                ? NetworkImage("${widget.userData?.avatar}")
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
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, */
    );
  }
}
