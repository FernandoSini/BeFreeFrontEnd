import 'dart:ffi';

import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/ListUsersProvider.dart';
import 'package:be_free_front/Providers/UserProvider.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:be_free_front/Screens/Profile/YourProfileScreen.dart';
import 'package:be_free_front/Screens/Profile/ProfileScreen.dart';
import 'package:be_free_front/Screens/clippers/CustomClipperRound.dart';
import 'package:be_free_front/Screens/clippers/OvalClipper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as universal;

class HomeScreen extends StatefulWidget {
  /* quando for pra release lembrar de tirar isso no ios info.plist
  <key>NSAppTransportSecurity</key>
  <dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict> */
  HomeScreen({this.userData});
  final User? userData;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();
  int page = 0;

  bool apiLoaded = false;
  void _logout(context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      await storage.deleteAll();

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      universal.window.sessionStorage.clear();
      universal.window.localStorage.clear();

      // localStorage.clear();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
    // Provider.of<ListUsersProvider>(context).dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<ListUsersProvider>(context, listen: false)
          .getListOfUsersByYourGender(widget.userData);

      if (JwtDecoder.isExpired(widget.userData!.token!)) {
        await storage.deleteAll();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });

    // print(dataFromAPI);
    // Provider.of<ListUsersProvider>(context, listen: false)
    //     .getListOfUsersByYourGender(widget.userData);
    super.initState();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        Provider.of<ListUsersProvider>(context, listen: false).dispose();
      }
      if (JwtDecoder.isExpired(widget.userData!.token!)) {
        await storage.deleteAll();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });

    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) async {
  //     await Provider.of<ListUsersProvider>(context, listen: false)
  //         .getListOfUsersByYourGender(widget.userData);
  //   });

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListUsersProvider>(context);

    return Scaffold(
      appBar: !(defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Consumer<UserProvider>(
                builder: (_, userProvider, __) {
                  userProvider.setUser(widget.userData);
                  return Text(
                    userProvider.user?.userName != null
                        ? "Welcome ${userProvider.user?.userName} ${userProvider.user?.lastName}"
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
                Consumer<UserProvider>(
                  builder: (_, userProvider, __) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => YourProfileScreen()));
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/avatars/avatar.png"),
                              foregroundImage: NetworkImage(
                                "${userProvider.user?.avatar}",
                                headers: {
                                  "Content-type": "application/json",
                                  'Access-Control-Allow-Methods': '*',
                                  'Access-Control-Allow-Origin': '*',
                                  'Access-Control-Allow-Headers': '*'
                                },
                              ),
                            ),
                          ),
                          Text(
                            "${userProvider.user?.userName}",
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
                    _logout(context);
                  },
                ),
              ],
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.black),
              title: Consumer<UserProvider>(
                builder: (_, userProvider, __) {
                  userProvider.setUser(widget.userData);
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
      // backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          print(constraints.maxHeight);
          if (!listProvider.isLoading) {
            return Consumer<ListUsersProvider>(
              builder: (_, listUserProvider, __) {
                listUserProvider.userList!.removeWhere((User? element) =>
                    element!.idUser! == widget.userData!.idUser);

                return PageView.builder(
                  itemCount: listUserProvider.userList!.length,
                  pageSnapping: true,
                  physics: BouncingScrollPhysics(),
                  allowImplicitScrolling: true,
                  itemBuilder: (_, index) {
                    return Container(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 50),
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    ClipPath(
                                      clipper: OvalBottomBorderClipper(),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.73,
                                        color: Color(0xFF9a00e6),
                                      ),
                                    ),
                                    ClipPath(
                                      clipper: OvalBottomBorderClipper(),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.72,
                                        // color: Colors.blue,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: listUserProvider
                                                        .userList?[index]
                                                        .avatar !=
                                                    null
                                                ? NetworkImage(
                                                    "${listUserProvider.userList?[index].avatar}")
                                                : AssetImage(
                                                        "assets/avatars/avatar2.png")
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.67,
                                left: 75,
                                // bottom: 500,
                                child: ElevatedButton(
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 35,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      minimumSize: Size(60, 60),
                                      primary:
                                          Color(0xFF9a00e6).withOpacity(0.8)),
                                  onPressed: () {
                                    setState(() {
                                      listProvider.userList?.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.67,
                                left: MediaQuery.of(context).size.width * 0.67,
                                // bottom: 500,
                                child: ElevatedButton(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 35,
                                    color: Colors.pink[100],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      minimumSize: Size(60, 60),
                                      primary:
                                          Color(0xFF9a00e6).withOpacity(0.8)),
                                  onPressed: () {},
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.63,
                                left: MediaQuery.of(context).size.width * 0.83,
                                // bottom: 500,
                                child: ElevatedButton(
                                  child: Text(
                                    "i",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      minimumSize: Size(40, 40),
                                      primary:
                                          Color(0xFF9a00e6).withOpacity(0.8)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProfileScreen(
                                            user: listUserProvider
                                                .userList?[index]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).size.height * 0.68,
                                left: MediaQuery.of(context).size.width * 0.43,
                                // bottom: 500,
                                child: ElevatedButton(
                                  child: Icon(
                                    Icons.email_rounded,
                                    size: 35,
                                    color: Colors.yellowAccent[200],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      minimumSize: Size(70, 70),
                                      primary:
                                          Color(0xFF9a00e6).withOpacity(0.8)),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.transparent,
                            margin: EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            child: Text(
                              "${listUserProvider.userList?[index].userName} ${listUserProvider.userList?[index].lastName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 13),
                            alignment: Alignment.center,
                            child: Text(
                              "${widget.userData?.birthday}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}