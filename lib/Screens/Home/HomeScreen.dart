import 'dart:ffi';

import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/LikeProvider.dart';
import 'package:be_free_v1/Providers/ListUsersProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/Home/components/FilterScreen.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Screens/Profile/YourProfileScreen.dart';
import 'package:be_free_v1/Screens/Profile/ProfileScreen.dart';
import 'package:be_free_v1/Screens/clippers/OvalClipper.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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
      Provider.of<UserProvider>(context, listen: false).setUser(null);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      universal.window.sessionStorage.clear();
      universal.window.localStorage.clear();

      // localStorage.clear();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
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

    super.initState();
  }

  @override
  void didChangeDependencies() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (JwtDecoder.isExpired(widget.userData!.token!)) {
        await storage.deleteAll();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        Provider.of<ListUsersProvider>(context, listen: false).dispose();
        Provider.of<UserProvider>(context, listen: false).dispose();
        if (JwtDecoder.isExpired(widget.userData!.token!)) {
          await storage.deleteAll();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      }
    });
    super.dispose();
  }

  Future<void> showErrorDialog() async {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Error"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 100),
                child: TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF9a00e6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text("Error, You've already liked this user"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListUsersProvider>(context);
    final likeProvider = Provider.of<LikeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          brightness: Brightness.dark,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Consumer<UserProvider>(
            builder: (_, userProvider, __) {
              return Text(
                "BeFree",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Colors.pink[400],
                  fontSize: (defaultTargetPlatform == TargetPlatform.android ||
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
              icon: Icon(Icons.format_list_bulleted),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => FilterScreen(),
                    fullscreenDialog: true,
                    maintainState: false,
                  ),
                );
              },
            ),
            // IconButton(
            //   icon: Icon(Icons.exit_to_app),
            //   onPressed: () {
            //     _logout(context);
            //   },
            // ),
          ],
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (Responsive.isTooLargeScreen(context))
                  if (!listProvider.isLoading)
                    if (listProvider.userList!.isEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 300,
                              ),
                              Container(
                                child: Icon(
                                  Icons.sentiment_dissatisfied_sharp,
                                  size: 150,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  "Sorry, the list of users is empty",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Consumer<ListUsersProvider>(
                          builder: (_, listUserProvider, __) {
                            listUserProvider.userList!.removeWhere(
                                (User? element) =>
                                    element!.id! == widget.userData!.id);
                            return PageView.builder(
                              itemCount: listUserProvider.userList!.length,
                              pageSnapping: true,
                              physics: BouncingScrollPhysics(),
                              allowImplicitScrolling: true,
                              itemBuilder: (_, index) {
                                return Container(
                                  color: Colors.white,
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
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.73,
                                                    color: Color(0xFF9a00e6),
                                                  ),
                                                ),
                                                ClipPath(
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.72,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: listUserProvider
                                                                    .userList?[
                                                                        index]
                                                                    .avatarProfile !=
                                                                null
                                                            ? NetworkImage(
                                                                "http://192.168.0.22:3000/api/${listUserProvider.userList?[index].avatarProfile!.path}")
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
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 35,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                setState(() {
                                                  listProvider.userList
                                                      ?.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.68,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.favorite,
                                                size: 35,
                                                color: Colors.pinkAccent[100],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () async {
                                                likeProvider.setLike(
                                                    widget.userData!.id,
                                                    listUserProvider
                                                        .userList![index].id!,
                                                    widget.userData!.token!);
                                                if (likeProvider.isLiked) {
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                                if (likeProvider.hasError) {
                                                  await showErrorDialog();
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.64,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.88,
                                            child: ElevatedButton(
                                              child: Text(
                                                "i",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(40, 40),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProfileScreen(
                                                      user: listUserProvider
                                                          .userList![index],
                                                    ),
                                                    maintainState: true,
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.69,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.46,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.forward_to_inbox_sharp,
                                                size: 35,
                                                color: Colors.yellowAccent[200],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(70, 70),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
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
                                          "${listUserProvider.userList?[index].username} ${listUserProvider.userList?[index].lastname}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 13),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(listUserProvider.userList![index].birthday!).year}, years",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                  else
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),
                    )
                else if (Responsive.isLargeScreen(context))
                  if (!listProvider.isLoading)
                    if (listProvider.userList!.isEmpty)
                      Container(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 300,
                              ),
                              Container(
                                child: Icon(
                                  Icons.sentiment_dissatisfied_sharp,
                                  size: 150,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  "Sorry, the list of users is empty",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Consumer<ListUsersProvider>(
                          builder: (_, listUserProvider, __) {
                            listUserProvider.userList!.removeWhere(
                                (User? element) =>
                                    element!.id! == widget.userData!.id);
                            return PageView.builder(
                              itemCount: listUserProvider.userList!.length,
                              pageSnapping: true,
                              physics: BouncingScrollPhysics(),
                              allowImplicitScrolling: true,
                              itemBuilder: (_, index) {
                                return Container(
                                  color: Colors.white,
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
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.73,
                                                    color: Color(0xFF9a00e6),
                                                  ),
                                                ),
                                                ClipPath(
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.72,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: listUserProvider
                                                                    .userList?[
                                                                        index]
                                                                    .avatarProfile !=
                                                                null
                                                            ? NetworkImage(
                                                                "http://192.168.0.22:3000/api/${listUserProvider.userList?[index].avatarProfile!.path}")
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
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: 75,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 35,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                setState(() {
                                                  listProvider.userList
                                                      ?.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.64,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.favorite,
                                                size: 35,
                                                color: Colors.pinkAccent[100],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () async {
                                                likeProvider.setLike(
                                                    widget.userData!.id,
                                                    listUserProvider
                                                        .userList![index].id!,
                                                    widget.userData!.token!);
                                                if (likeProvider.isLiked) {
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                                if (likeProvider.hasError) {
                                                  await showErrorDialog();
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.63,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.83,
                                            child: ElevatedButton(
                                              child: Text(
                                                "i",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(40, 40),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProfileScreen(
                                                      user: listUserProvider
                                                          .userList![index],
                                                    ),
                                                    maintainState: true,
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.68,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.41,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.forward_to_inbox_sharp,
                                                size: 35,
                                                color: Colors.yellowAccent[200],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(70, 70),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
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
                                          "${listUserProvider.userList?[index].username} ${listUserProvider.userList?[index].lastname}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 13),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(listUserProvider.userList![index].birthday!).year}, years",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                  else
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),
                    )
                else if (Responsive.isMediumScreen(context))
                  if (!listProvider.isLoading)
                    if (listProvider.userList!.isEmpty)
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 300,
                              ),
                              Container(
                                child: Icon(
                                  Icons.sentiment_dissatisfied_sharp,
                                  size: 150,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(
                                  "Sorry, the list of users is empty",
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Consumer<ListUsersProvider>(
                          builder: (_, listUserProvider, __) {
                            listUserProvider.userList!.removeWhere(
                                (User? element) =>
                                    element!.id! == widget.userData!.id);
                            return PageView.builder(
                              itemCount: listUserProvider.userList!.length,
                              pageSnapping: true,
                              physics: BouncingScrollPhysics(),
                              allowImplicitScrolling: true,
                              itemBuilder: (_, index) {
                                return Container(
                                  color: Colors.white,
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
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.73,
                                                    color: Color(0xFF9a00e6),
                                                  ),
                                                ),
                                                ClipPath(
                                                  clipper:
                                                      OvalBottomBorderClipper(),
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.72,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: listUserProvider
                                                                    .userList?[
                                                                        index]
                                                                    .avatarProfile !=
                                                                null
                                                            ? NetworkImage(
                                                                "http://192.168.0.22:3000/api/${listUserProvider.userList?[index].avatarProfile!.path}")
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
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: 75,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.close_rounded,
                                                size: 35,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                setState(() {
                                                  listProvider.userList
                                                      ?.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.67,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.64,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.favorite,
                                                size: 35,
                                                color: Colors.pinkAccent[100],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(60, 60),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () async {
                                                likeProvider.setLike(
                                                    widget.userData!.id,
                                                    listUserProvider
                                                        .userList![index].id!,
                                                    widget.userData!.token!);
                                                if (likeProvider.isLiked) {
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                                if (likeProvider.hasError) {
                                                  await showErrorDialog();
                                                  setState(() {
                                                    listUserProvider.userList!
                                                        .remove(listUserProvider
                                                            .userList![index]);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.62,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.83,
                                            child: ElevatedButton(
                                              child: Text(
                                                "i",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(40, 40),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProfileScreen(
                                                      user: listUserProvider
                                                          .userList![index],
                                                    ),
                                                    maintainState: true,
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Positioned(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.68,
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: ElevatedButton(
                                              child: Icon(
                                                Icons.forward_to_inbox_sharp,
                                                size: 35,
                                                color: Colors.yellowAccent[200],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  minimumSize: Size(70, 70),
                                                  primary: Color(0xFF9a00e6)
                                                      .withOpacity(0.8)),
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
                                          "${listUserProvider.userList?[index].username} ${listUserProvider.userList?[index].lastname}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 13),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(listUserProvider.userList![index].birthday!).year}, years",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                  else
                    Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ),
                      ),
                    )
                else if (!listProvider.isLoading)
                  if (listProvider.userList!.isEmpty)
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 300,
                            ),
                            Container(
                              child: Icon(
                                Icons.sentiment_dissatisfied_sharp,
                                size: 150,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                "Sorry, the list of users is empty",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Consumer<ListUsersProvider>(
                        builder: (_, listUserProvider, __) {
                          listUserProvider.userList!.removeWhere(
                              (User? element) =>
                                  element!.id! == widget.userData!.id);
                          return PageView.builder(
                            itemCount: listUserProvider.userList!.length,
                            pageSnapping: true,
                            physics: BouncingScrollPhysics(),
                            allowImplicitScrolling: true,
                            itemBuilder: (_, index) {
                              return Container(
                                color: Colors.white,
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
                                                clipper:
                                                    OvalBottomBorderClipper(),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.66,
                                                  color: Color(0xFF9a00e6),
                                                ),
                                              ),
                                              ClipPath(
                                                clipper:
                                                    OvalBottomBorderClipper(),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.65,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: listUserProvider
                                                                  .userList?[
                                                                      index]
                                                                  .avatarProfile !=
                                                              null
                                                          ? NetworkImage(
                                                              "http://192.168.0.22:3000/api/${listUserProvider.userList?[index].avatarProfile!.path}")
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
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.58,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 35,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                minimumSize: Size(60, 60),
                                                primary: Color(0xFF9a00e6)
                                                    .withOpacity(0.8)),
                                            onPressed: () {
                                              setState(() {
                                                listProvider.userList
                                                    ?.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.58,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.64,
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.favorite,
                                              size: 35,
                                              color: Colors.pinkAccent[100],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                minimumSize: Size(60, 60),
                                                primary: Color(0xFF9a00e6)
                                                    .withOpacity(0.8)),
                                            onPressed: () async {
                                              likeProvider.setLike(
                                                  widget.userData!.id,
                                                  listUserProvider
                                                      .userList![index].id!,
                                                  widget.userData!.token!);
                                              if (likeProvider.isLiked) {
                                                setState(() {
                                                  listUserProvider.userList!
                                                      .remove(listUserProvider
                                                          .userList![index]);
                                                });
                                              }
                                              if (likeProvider.hasError) {
                                                await showErrorDialog();
                                                setState(() {
                                                  listUserProvider.userList!
                                                      .remove(listUserProvider
                                                          .userList![index]);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.53,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.83,
                                          child: ElevatedButton(
                                            child: Text(
                                              "i",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              minimumSize: Size(40, 40),
                                              primary: Color(0xFF9a00e6)
                                                  .withOpacity(0.8),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => ProfileScreen(
                                                    user: listUserProvider
                                                        .userList![index],
                                                  ),
                                                  maintainState: true,
                                                  fullscreenDialog: true,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.60,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.41,
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.forward_to_inbox_sharp,
                                              size: 35,
                                              color: Colors.yellowAccent[200],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                minimumSize: Size(70, 70),
                                                primary: Color(0xFF9a00e6)
                                                    .withOpacity(0.8)),
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
                                        "${listUserProvider.userList?[index].username} ${listUserProvider.userList?[index].lastname}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(listUserProvider.userList![index].birthday!).year}, years",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                else
                  Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
