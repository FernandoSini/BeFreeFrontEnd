import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/MatchProvider.dart';
import 'package:be_free_front/Screens/Chat/ChatScreen.dart';
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
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<MatchProvider>(context, listen: false)
          .getMatches(widget.user!.token!, widget.user!.idUser!);
    });
    super.initState();
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
                "Your Matches",
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
              child: Consumer<MatchProvider>(
                builder: (context, matchProvider, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: matchProvider.matchData?.length,
                    itemBuilder: (context, index) {
                      if (!matchProvider.isLoading) {
                        if (matchProvider.matchData!.isEmpty) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  user: matchProvider.matches![index].hisHer,
                                  you: widget.user,
                                  match: matchProvider.matches![index],
                                ),
                                fullscreenDialog: true,
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
                                backgroundImage: matchProvider.matches?[index]
                                            .hisHer!.avatarProfile !=
                                        null
                                    ? NetworkImage(
                                        "${matchProvider.matches?[index].hisHer!.avatarProfile!.url}")
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
                "Messages",
                style: TextStyle(
                  fontFamily: "Segoe",
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9a00e6),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: Consumer<MatchProvider>(
                builder: (_, matchProvider, __) {
                  if (!matchProvider.isLoading) {
                    if (matchProvider.matchData!.isEmpty) {
                      return Container();
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
                                user: matchProvider.matches![index].hisHer,
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
                                      child: CircleAvatar(
                                        backgroundImage: matchProvider
                                                    .matches?[index]
                                                    .hisHer!
                                                    .avatarProfile !=
                                                null
                                            ? NetworkImage(
                                                "${matchProvider.matches?[index].hisHer!.avatarProfile!.url}")
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
                                                    child: Text(
                                                      "${matchProvider.matches?[index].hisHer?.userName} ${matchProvider.matches?[index].hisHer?.lastName}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors
                                                            .pinkAccent[400],
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
                      margin: EdgeInsets.only(bottom: 250),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Color(0xff9a00e6),
                          ),
                        ),
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
