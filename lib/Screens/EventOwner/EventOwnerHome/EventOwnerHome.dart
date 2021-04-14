import 'package:be_free_front/Models/EventOwner.dart';
import 'package:be_free_front/Providers/EventOwnerProvider.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class EventOwnerHome extends StatelessWidget {
  EventOwnerHome({this.eventOwner});
  EventOwner? eventOwner;
  final storage = new FlutterSecureStorage();

  void _logout(context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      await storage.deleteAll();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } /* else {
      universal.window.sessionStorage.clear();
      universal.window.localStorage.clear();

      // localStorage.clear();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } */
    // Provider.of<ListUsersProvider>(context).dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventOwnerProvider = Provider.of<EventOwnerProvider>(context);
    return Scaffold(
      appBar: !(defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Consumer<EventOwnerProvider>(
                builder: (_, eventOwnerProvider, __) {
                  eventOwnerProvider.setEventOwner(eventOwner);
                  return Text(
                    eventOwnerProvider.eventOwner?.eventOwnerName != null
                        ? "Welcome ${eventOwnerProvider.eventOwner?.eventOwnerName}"
                        : "BeFree",
                    style: TextStyle(
                      fontFamily: "Segoe",
                      color: Color(0xFF9a00e6),
                      fontSize:
                          (defaultTargetPlatform == TargetPlatform.android ||
                                  defaultTargetPlatform == TargetPlatform.iOS)
                              ? 30
                              : 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              actions: [
                Consumer<EventOwnerProvider>(
                  builder: (_, eventOwnerProvider, __) {
                    return GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) => YourProfileScreen()));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/avatars/avatar.png"),
                              foregroundImage: eventOwner?.avatar != null
                                  ? NetworkImage(
                                      "${eventOwner?.avatar}",
                                      headers: {
                                        "Content-type": "application/json",
                                        'Access-Control-Allow-Methods': '*',
                                        'Access-Control-Allow-Origin': '*',
                                        'Access-Control-Allow-Headers': '*'
                                      },
                                    )
                                  : AssetImage("assets/avatars/avatar2.png")
                                      as ImageProvider,
                            ),
                          ),
                          Text(
                            "${eventOwnerProvider.eventOwner?.eventOwnerName}",
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF9a00e6)),
                          )
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    // _logout(context);
                  },
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              title: Consumer<EventOwnerProvider>(
                builder: (_, eventOwnerProvider, __) {
                  eventOwnerProvider.setEventOwner(eventOwner);
                  return Text(
                    /* userProvider.user?.userName != null
                        ? "Welcome ${userProvider.user?.userName}"
                        : */
                    "BeFree",
                    style: TextStyle(
                      fontFamily: "Segoe",
                      color: Colors.pink[400],
                      fontSize:
                          (defaultTargetPlatform == TargetPlatform.android ||
                                  defaultTargetPlatform == TargetPlatform.iOS)
                              ? 30
                              : 50,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              actionsIconTheme: IconThemeData(color: Color(0xFF9a00e6)),
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _logout(context);
                  },
                ),
              ],
            ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
