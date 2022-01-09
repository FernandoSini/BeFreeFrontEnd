import 'dart:io';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/LikesReceivedProvider.dart';
import 'package:be_free_v1/Providers/MatchProvider.dart';
import 'package:be_free_v1/Screens/Chat/ChatScreen.dart';
import 'package:be_free_v1/Screens/Profile/ProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchesScreen extends StatefulWidget {
  MatchesScreen({this.user});
  User? user;

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  @override
  void didChangeDependencies() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<MatchProvider>(context, listen: false)
          .getMatches(widget.user!.token!, widget.user!.id!);
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<LikesReceivedProvider>(context, listen: false)
          .getLikesReceived(widget.user!.token!, widget.user!.id!);
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        Provider.of<MatchProvider>(context, listen: false).dispose();
        Provider.of<MatchProvider>(context, listen: false).clear();
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<LikesReceivedProvider>(context, listen: false).dispose();
        Provider.of<LikesReceivedProvider>(context, listen: false).clear();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        elevation: 0,
        title: Text(
          "Matches",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.inbox, color: Color(0xff9a00e6)),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
              child: Text(
                "Who like You",
                style: TextStyle(
                  fontFamily: "Segoe",
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9a00e6),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              alignment: Alignment.center,
              child: Consumer<LikesReceivedProvider>(
                builder: (context, likesReceivedProvider, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: likesReceivedProvider.likesReceived?.length,
                    itemBuilder: (context, index) {
                      likesReceivedProvider.likesData
                          ?.whereType<User>()
                          .toList();
                      if (!likesReceivedProvider.isLoading) {
                        if (likesReceivedProvider.likesData!.isEmpty) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                    user: likesReceivedProvider
                                        .likesReceived![index]),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Center(
                              child: CircleAvatar(
                                backgroundImage: likesReceivedProvider
                                            .likesData?[index].avatarProfile !=
                                        null
                                    ? NetworkImage(
                                        "${likesReceivedProvider.likesReceived?[index].avatarProfile!.path}")
                                    : AssetImage("assets/avatars/avatar2.png")
                                        as ImageProvider,
                                radius: 50,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator.adaptive(
                              valueColor: AlwaysStoppedAnimation(
                                Color(0xff9a00e6),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, bottom: 10, top: 20),
              child: Text(
                "Matches",
                style: TextStyle(
                  fontFamily: "Segoe",
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9a00e6),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              child: Consumer<MatchProvider>(
                builder: (_, matchProvider, __) {
                  if (!matchProvider.isLoading) {
                    if (matchProvider.matchData!.isEmpty) {
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(matchProvider.errorData),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: matchProvider.matchData?.length,
                      padding: EdgeInsets.only(bottom: 50),
                      itemBuilder: (context, index) => InkWell(
                        onLongPress: () async {
                          if (Platform.isAndroid) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Match",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to unmatch?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        // var deleted =
                                        //     await deleteAvatar(context)
                                        //         .then((value) {
                                        //   setState(() {
                                        //     widget.userData?.avatarProfile =
                                        //         null;
                                        //     userProvider.updateDataSecurePlace(
                                        //         widget.userData);
                                        //   });
                                        //   return value;
                                        // });

                                        // if (deleted!) {
                                        //   setState(() {
                                        //     widget.userData?.avatarProfile =
                                        //         null;
                                        //   });
                                        // }
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
                                    "Delete Match",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to unmatch?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        // var deleted =
                                        //     await deleteAvatar(context)
                                        //         .then((value) {
                                        //   setState(() {
                                        //     widget.userData?.avatarProfile =
                                        //         null;
                                        //         userProvider.updateDataSecurePlace(
                                        //         widget.userData);
                                        //   });
                                        //   return value;
                                        // });
                                        // print(deleted);
                                        // if (deleted!) {
                                        //   setState(() {
                                        //     widget.userData?.avatarProfile =
                                        //         null;
                                        //   });
                                        // }
                                        setState(() {
                                          matchProvider.matches
                                              ?.removeAt(index);
                                        });

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
                        onTap: () async {
                          if (matchProvider.matches![index].user1 == null ||
                              matchProvider.matches![index].user2 == null) {
                            if (Platform.isAndroid) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      "Warning",
                                      style: TextStyle(
                                        color: Color(0xFF9a00e6),
                                      ),
                                    ),
                                    content: Text(
                                        "Can't chat because this user deleted his/her account"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Okay",
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
                                      "Warning",
                                      style: TextStyle(
                                        color: Color(0xFF9a00e6),
                                      ),
                                    ),
                                    content: Text(
                                        "Can't chat because this user deleted his/her account"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Okay",
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
                          } else {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatScreen(
                                      user: matchProvider
                                                  .matches![index].user1?.id ==
                                              widget.user?.id
                                          ? matchProvider.matches![index].user2
                                          : matchProvider.matches![index].user1,
                                      you: widget.user,
                                      match: matchProvider.matches![index],
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                )
                                .then(
                                  (value) => setState(
                                    () {
                                      if (value != null) {
                                        // matchProvider.matches?[index].messages =
                                        //     value;
                                        value.forEach((element) {
                                          if (element.matchId ==
                                              matchProvider
                                                  .matches?[index].matchId) {
                                            matchProvider
                                                .matches?[index].messages
                                                ?.add(element);
                                          }
                                        });
                                      }
                                    },
                                  ),
                                );
                          }
                        },
                        child: Container(
                          child: Column(
                            children: [
                              if (matchProvider.matches![index].user1 != null &&
                                  matchProvider.matches![index].user2 != null)
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: matchProvider.matches![index]
                                                    .user1?.id ==
                                                widget.user?.id
                                            ? CircleAvatar(
                                                backgroundImage: matchProvider
                                                            .matches?[index]
                                                            .user2! //ta aqui o erro
                                                            .avatarProfile !=
                                                        null
                                                    ? NetworkImage(
                                                        "${matchProvider.matches?[index].user2!.avatarProfile!.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                radius: 40,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: matchProvider
                                                            .matches?[index]
                                                            .user1!
                                                            .avatarProfile !=
                                                        null
                                                    ? NetworkImage(
                                                        "${matchProvider.matches?[index].user1!.avatarProfile!.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                radius: 40,
                                              ),
                                      ),
                                      Container(
                                        child: Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 20),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                  child:
                                                      matchProvider
                                                                  .matches![
                                                                      index]
                                                                  .user1
                                                                  ?.id ==
                                                              widget.user?.id
                                                          ? Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "${matchProvider.matches?[index].user2?.username} ",
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                              .pinkAccent[
                                                                          400],
                                                                    ),
                                                                  ),
                                                                  if (matchProvider
                                                                      .matches![
                                                                          index]
                                                                      .messages!
                                                                      .isNotEmpty)
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: 3,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        DateFormat("HH:mm").format(matchProvider
                                                                            .matches![index]
                                                                            .messages!
                                                                            .last
                                                                            .timestamp!
                                                                            .toLocal()),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            )
                                                          : Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "${matchProvider.matches?[index].user1?.username} ",
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .pinkAccent[400],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (matchProvider
                                                                      .matches![
                                                                          index]
                                                                      .messages!
                                                                      .isNotEmpty)
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        top: 3,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        DateFormat("HH:mm").format(matchProvider
                                                                            .matches![index]
                                                                            .messages!
                                                                            .last
                                                                            .timestamp!
                                                                            .toLocal()),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 70),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: matchProvider
                                                                .matches![index]
                                                                .messages!
                                                                .isNotEmpty
                                                            ? Row(
                                                                children: [
                                                                  // matchProvider.matches![index].messages!.last.messageStatus ==
                                                                  //         MessageStatus.DELIVERED
                                                                  //     ? Icon(
                                                                  //         Icons.done_all,
                                                                  //         color: Colors.blueAccent,
                                                                  //       )
                                                                  //     : Icon(Icons.done),
                                                                  Expanded(
                                                                    child: Text(
                                                                      "${matchProvider.matches?[index].messages?.last.content}",
                                                                      overflow: matchProvider.matches![index].messages!.last.content!.length >=
                                                                              15
                                                                          ? TextOverflow
                                                                              .ellipsis
                                                                          : null,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                "No messages sent/received yet",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/avatars/avatar2.png"),
                                          radius: 40,
                                        ),
                                      ),
                                      Container(
                                        child: Flexible(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 10, right: 20),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "User deleted",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color: Colors
                                                                    .pinkAccent[
                                                                400],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 70),
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: Text(
                                                          "User Deleted",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Divider(
                                indent: 15,
                                endIndent: 15,
                                thickness: 0.3,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xff9a00e6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
