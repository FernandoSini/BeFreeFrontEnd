import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/LikesReceivedProvider.dart';
import 'package:be_free_v1/Providers/MatchProvider.dart';
import 'package:be_free_v1/Screens/Chat/ChatScreen.dart';
import 'package:be_free_v1/Screens/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchesScreen extends StatefulWidget {
  MatchesScreen({this.user});
  User? user;

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  @override
  void didChangeDependencies() {
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
        Provider.of<LikesReceivedProvider>(context, listen: false).dispose();
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
          IconButton(
            icon: Icon(Icons.inbox, color: Color(0xff9a00e6)),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
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
                      if (!likesReceivedProvider.isLoading) {
                        if (likesReceivedProvider.likesData!.isEmpty) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (_) => ChatScreen(
                            //       user: matchProvider.matches![index].user1,
                            //       you: widget.user,
                            //       match: matchProvider.matches![index],
                            //     ),
                            //     fullscreenDialog: true,
                            //   ),
                            // );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                    user: likesReceivedProvider
                                        .likesReceived![index]),
                              ),
                            );
                          },
                          // child: Container(
                          //   padding: EdgeInsets.only(left: 10, right: 10),
                          //   child: CircleAvatar(
                          //     radius: 50,
                          //     child: ClipOval(
                          //       child: matchProvider
                          //                   .matches?[index].hisHer?.avatar !=
                          //               null
                          //           ? Image.network(
                          //               "${matchProvider.matches?[index].hisHer!.avatar}",
                          //               height: 100,
                          //               fit: BoxFit.cover,
                          //             )
                          //           : Image.asset("assets/avatars/avatar2.png"),
                          //     ),
                          //     // backgroundImage: matchProvider
                          //     //             .matches?[index].hisHer?.avatar !=
                          //     //         null
                          //     //     ? NetworkImage(
                          //     //         "${matchProvider.matches?[index].hisHer!.avatar}")
                          //     //     : AssetImage("assets/avatars/avatar2.png")
                          //     //         as ImageProvider,
                          //     // backgroundColor: Colors.transparent,
                          //     // minRadius: 10,
                          //     // maxRadius: 30,
                          //   ),
                          // ),
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Center(
                              child: CircleAvatar(
                                backgroundImage: likesReceivedProvider
                                            .likesData?[index].avatarProfile !=
                                        null
                                    ? NetworkImage(
                                        "http://192.168.0.22:3000/api/${likesReceivedProvider.likesReceived?[index].avatarProfile!.path}")
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
                      // shrinkWrap: true,
                      // clipBehavior: Clip.none,
                      physics: BouncingScrollPhysics(),
                      itemCount: matchProvider.matchData?.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                user: matchProvider.matches![index].user1?.id ==
                                        widget.user?.id
                                    ? matchProvider.matches![index].user2
                                    : matchProvider.matches![index].user1,
                                you: widget.user,
                                match: matchProvider.matches![index],
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      child: matchProvider
                                                  .matches![index].user1?.id ==
                                              widget.user?.id
                                          ? CircleAvatar(
                                              backgroundImage: matchProvider
                                                          .matches?[index]
                                                          .user2!
                                                          .avatarProfile !=
                                                      null
                                                  ? NetworkImage(
                                                      "http://192.168.0.22:3000/api/${matchProvider.matches?[index].user1!.avatarProfile!.path}")
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
                                                      "http://192.168.0.22:3000/api/${matchProvider.matches?[index].user1!.avatarProfile!.path}")
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
                                              margin: EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20),
                                                    child: matchProvider
                                                                .matches![index]
                                                                .user1
                                                                ?.id ==
                                                            widget.user?.id
                                                        ? Text(
                                                            "${matchProvider.matches?[index].user2?.username} ${matchProvider.matches?[index].user2?.lastname}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color: Colors
                                                                      .pinkAccent[
                                                                  400],
                                                            ),
                                                          )
                                                        : Text(
                                                            "${matchProvider.matches?[index].user1?.username} ${matchProvider.matches?[index].user1?.lastname}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color: Colors
                                                                      .pinkAccent[
                                                                  400],
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: matchProvider
                                                              .matches![index]
                                                              .messages!
                                                              .isNotEmpty
                                                          ? Text(
                                                              "${matchProvider.matches?[index].messages?.last.content}",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            )
                                                          : Text(
                                                              "No messages sent/received yet",
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
                      // margin: EdgeInsets.only(bottom: 250),
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
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   color: Colors.red,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     physics: BouncingScrollPhysics(),
            //     itemCount: 3,
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         child: Container(
            //           // color: Colors.black,
            //           margin: EdgeInsets.only(
            //             top: 30,
            //             bottom: 30,
            //             left: 20,
            //           ),
            //           padding: EdgeInsets.only(left: 10, right: 10),
            //           child: Container(
            //             // color: Colors.blue,
            //             child: Icon(
            //               Icons.email,
            //               size: 50,
            //             ),
            //             height: MediaQuery.of(context).size.height * 0.3,
            //             width: MediaQuery.of(context).size.width * 0.3,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(15),
            //               color: Colors.blue,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
