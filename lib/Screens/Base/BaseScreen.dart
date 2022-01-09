import 'package:be_free_v1/Api/api.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/Events/CreateEvent/CreateEventScreen.dart';
import 'package:be_free_v1/Screens/Matches/MatchesScreen.dart';
import 'package:be_free_v1/Screens/Events/EventsScreen.dart';
import 'package:be_free_v1/Screens/Home/HomeScreen.dart';

import 'package:be_free_v1/Screens/Profile/YourProfileScreen.dart';
import 'package:be_free_v1/Screens/Profile/components/PhotosScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({this.userData});
  User? userData;

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int page = 0;
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

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
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.nightlife),
                    activeIcon: Icon(
                      Icons.nightlife,
                      color: Colors.blue,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.whatshot_outlined),
                    activeIcon: Icon(
                      Icons.whatshot_outlined,
                      color: Colors.pinkAccent[400],
                    ),
                  ),
                  BottomNavigationBarItem(
                    tooltip: null,
                    icon: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: CircleAvatar(
                          backgroundImage:
                              widget.userData?.avatarProfile != null
                                  ? NetworkImage(
                                      "${widget.userData!.avatarProfile!.path}")
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
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    unselectedItemColor: Colors.grey,
                    backgroundColor: Colors.white,
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
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.nightlife),
                        activeIcon: Icon(
                          Icons.nightlife,
                          color: Color(0xffedc967),
                        ),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.whatshot_outlined),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        tooltip: null,
                        icon: Container(
                          padding: EdgeInsets.only(top: 7),
                          child: CircleAvatar(
                            backgroundImage: widget.userData?.avatarProfile !=
                                    null
                                ? NetworkImage(
                                    "${widget.userData!.avatarProfile!.path}")
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
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.Up,
        childrenButtonSize: 65,
        activeBackgroundColor: Color(0xFF9a00e6),
        spaceBetweenChildren: 5,
        backgroundColor: Color(0xFF9a00e6),
        icon: Icons.add,
        useRotationAnimation: true,
        overlayOpacity: 0,
        childPadding: EdgeInsets.only(left: 7.5),
        iconTheme: IconThemeData(size: 25),
        children: [
          SpeedDialChild(
            backgroundColor: Color(0xFF9a00e6),
            child: Icon(
              Icons.add_a_photo_outlined,
              color: Colors.white,
            ),
            label: "Add a photo",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PhotosScreen(user: widget.userData!),
                fullscreenDialog: true,
                maintainState: true,
              ),
            ),
          ),
          SpeedDialChild(
            backgroundColor: Color(0xFF9a00e6),
            child: Icon(
              FontAwesomeIcons.calendarPlus,
              color: Colors.white,
            ),
            label: "Create new event",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateEventScreen(widget.userData!),
                  fullscreenDialog: true,
                  maintainState: true,
                ),
              );
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
