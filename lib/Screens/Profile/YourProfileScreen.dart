import 'dart:convert';
import 'dart:io';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UpdateUserProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Screens/Profile/ChangeAvatarScreen.dart';
import 'package:be_free_v1/Screens/Profile/EditProfileScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class YourProfileScreen extends StatefulWidget {
  YourProfileScreen({this.userData});
  User? userData;

  @override
  _YourProfileScreenState createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<bool?> logoutFromServer() async {
    String? url = "${api.url}logout";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _logout(context) async {
    var isSignOut = await logoutFromServer();
    if (isSignOut!) {
      await storage.deleteAll();
      Provider.of<UserProvider>(context, listen: false).setUser(null);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
      );
    }
  }

  Future<bool?> deleteAvatar(BuildContext context) async {
    String url = "${api.url}api/users/${widget.userData?.id}/avatar/delete";
    http.Response response = await http.delete(Uri.parse(url), headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer ${widget.userData?.token}"
    });
    if (response.statusCode == 200) {
      await showSuccessDeleteDialog(context);
      return true;
    } else {
      String error = jsonDecode(response.body)["err"];
      await showDeleteErrorDialog(context, error);
      return false;
    }
  }

  Future<void> showSuccessDeleteDialog(context) async {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Success"),
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
                    Icons.check_circle_sharp,
                    color: Colors.green,
                    size: 80,
                  ),
                  Text("Deleted!"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteErrorDialog(context, String error) async {
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
                  Text("$error"),
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
    final updateUser = Provider.of<UpdateUserProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Profile",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () => _logout(context),
          )
        ],
        actionsIconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
      ),
      body: Responsive.isSmallScreen(context)
          ? Container(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => ChangeAvatarScreen(
                                    user: widget.userData,
                                  ),
                                ),
                              )
                              .then((value) => setState(() {
                                    if (value != null) {
                                      widget.userData?.avatarProfile = value;
                                    }
                                  }));
                        },
                        onLongPress: () async {
                          if (Platform.isAndroid) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Avatar",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete avatar?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var deleted =
                                            await deleteAvatar(context)
                                                .then((value) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          return value;
                                        });
                                        if (deleted!) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          userProvider.updateDataSecurePlace(
                                              widget.userData);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    "Delete Avatar",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete avatar?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var deleted =
                                            await deleteAvatar(context)
                                                .then((value) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          return value;
                                        });
                                        if (deleted!) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(65),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                border: Border.all(
                                  color: widget.userData!.gender == Gender.MALE
                                      ? Colors.blue
                                      : Colors.pinkAccent.shade400,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: widget
                                            .userData?.avatarProfile !=
                                        null
                                    ? NetworkImage(
                                        "${api.url}api/${widget.userData?.avatarProfile!.path}")
                                    : AssetImage("assets/avatars/avatar2.png")
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                                radius: 50,
                              ),
                            ),
                            Positioned(
                              left: 60,
                              top: 75,
                              child: Container(
                                height: 35,
                                width: 35,
                                child: Icon(Icons.edit, color: Colors.white),
                                decoration: BoxDecoration(
                                    color:
                                        widget.userData!.gender == Gender.MALE
                                            ? Colors.blue
                                            : Colors.pinkAccent.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.userData?.username}, " +
                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(widget.userData!.birthday!).year}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.userData?.firstname} ${widget.userData?.lastname}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${EnumToString.convertToString(widget.userData?.gender)}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 80, right: 80),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9a00e6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () {
                        updateUser.setBirthday(null);
                        updateUser.setNewAbout(null);
                        updateUser.setNewCompany(null);
                        updateUser.setNewEmail(null);
                        updateUser.setNewFirstName(null);
                        updateUser.setNewGender(null);
                        updateUser.setNewLastName(null);
                        updateUser.setNewUsername(null);
                        updateUser.setNewJob(null);
                        updateUser.setNewSchool(null);
                        updateUser.setNewLivesIn(null);
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => EditProfileScreen(
                                  userId: widget.userData!.id,
                                  token: widget.userData!.token,
                                ),
                              ),
                            )
                            .then(
                              (value) => setState(
                                () {
                                  if (value != null) {
                                    // widget.userData = value;
                                    widget.userData?.firstname =
                                        value.firstname;
                                    widget.userData?.lastname = value.lastname;
                                    widget.userData?.username = value.username;
                                    widget.userData?.birthday = value.birthday;
                                    widget.userData?.about = value.about;
                                    widget.userData?.company = value.company;
                                    widget.userData?.email = value.email;
                                    widget.userData?.job = value.job;
                                    widget.userData?.livesIn = value.livesIn;
                                    widget.userData?.school = value.school;
                                    widget.userData?.gender = value.gender;
                                    widget.userData?.photos = value.photos;
                                    widget.userData?.createdAt =
                                        value.createdAt;
                                    widget.userData?.usertype = value.usertype;
                                  }
                                },
                              ),
                            );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Container(
                  //   height: 50,
                  //   margin: EdgeInsets.only(left: 80, right: 80),
                  //   child: ElevatedButton.icon(
                  //     icon: Icon(Icons.exit_to_app_sharp),
                  //     label: Text("Logout"),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Color(0xFF9a00e6),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(22),
                  //       ),
                  //     ),
                  //     onPressed: () => _logout(context),
                  //   ),
                  // )
                ],
              ),
            )
          : Container(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => ChangeAvatarScreen(
                                    user: widget.userData,
                                  ),
                                ),
                              )
                              .then(
                                (value) => setState(
                                  () {
                                    if (value != null) {
                                      widget.userData?.avatarProfile = value;
                                    }
                                  },
                                ),
                              );
                        },
                        onLongPress: () async {
                          if (Platform.isAndroid) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Avatar",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete avatar?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var deleted =
                                            await deleteAvatar(context)
                                                .then((value) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          return value;
                                        });

                                        if (deleted!) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          userProvider.updateDataSecurePlace(
                                              widget.userData);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    "Delete Avatar",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete avatar?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var deleted =
                                            await deleteAvatar(context)
                                                .then((value) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                          return value;
                                        });
                                        print(deleted);
                                        if (deleted!) {
                                          setState(() {
                                            widget.userData?.avatarProfile =
                                                null;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(65),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                border: Border.all(
                                  color: widget.userData!.gender == Gender.MALE
                                      ? Colors.blue
                                      : Colors.pinkAccent.shade400,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: widget
                                            .userData?.avatarProfile !=
                                        null
                                    ? NetworkImage(
                                        "${api.url}api/${widget.userData?.avatarProfile!.path}")
                                    : AssetImage("assets/avatars/avatar2.png")
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                                radius: 80,
                              ),
                            ),
                            Positioned(
                              left: 110,
                              top: 130,
                              child: Container(
                                height: 35,
                                width: 35,
                                child: Icon(Icons.edit, color: Colors.white),
                                decoration: BoxDecoration(
                                    color:
                                        widget.userData!.gender == Gender.MALE
                                            ? Colors.blue
                                            : Colors.pinkAccent.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.userData?.username}, " +
                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(widget.userData!.birthday!).year}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.userData?.firstname} ${widget.userData?.lastname}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${EnumToString.convertToString(widget.userData?.gender)}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.only(left: 80, right: 80),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit),
                      label: Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9a00e6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      onPressed: () {
                        updateUser.setBirthday(null);
                        updateUser.setNewAbout(null);
                        updateUser.setNewCompany(null);
                        updateUser.setNewEmail(null);
                        updateUser.setNewFirstName(null);
                        updateUser.setNewGender(null);
                        updateUser.setNewLastName(null);
                        updateUser.setNewUsername(null);
                        updateUser.setNewJob(null);
                        updateUser.setNewSchool(null);
                        updateUser.setNewLivesIn(null);
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              userId: widget.userData!.id,
                              token: widget.userData!.token,
                            ),
                          ),
                        )
                            .then(
                          (value) {
                            if (value != null) {
                              // widget.userData = value;
                              widget.userData?.firstname = value.firstname;
                              widget.userData?.lastname = value.lastname;
                              widget.userData?.username = value.username;
                              widget.userData?.birthday = value.birthday;
                              widget.userData?.about = value.about;
                              widget.userData?.company = value.company;
                              widget.userData?.email = value.email;
                              widget.userData?.job = value.job;
                              widget.userData?.livesIn = value.livesIn;
                              widget.userData?.school = value.school;
                              widget.userData?.gender = value.gender;
                              widget.userData?.photos = value.photos;
                              widget.userData?.createdAt = value.createdAt;
                              widget.userData?.usertype = value.usertype;
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // Container(
                  //   height: 50,
                  //   margin: EdgeInsets.only(left: 80, right: 80),
                  //   child: ElevatedButton.icon(
                  //     icon: Icon(Icons.exit_to_app_sharp),
                  //     label: Text("Logout"),
                  //     style: ElevatedButton.styleFrom(
                  //       primary: Color(0xFF9a00e6),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(22),
                  //       ),
                  //     ),
                  //     onPressed: () => _logout(context),
                  //   ),
                  // )
                ],
              ),
            ),
    );
  }
}
