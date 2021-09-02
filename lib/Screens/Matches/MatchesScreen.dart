import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/LikesReceivedProvider.dart';
import 'package:be_free_v1/Providers/MatchProvider.dart';
import 'package:be_free_v1/Screens/Chat/ChatScreen.dart';
import 'package:be_free_v1/Screens/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MatchesScreen extends StatefulWidget {
  MatchesScreen({this.user});
  User? user;

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
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
      }
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
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
                                        "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${likesReceivedProvider.likesReceived?[index].avatarProfile!.path}")
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
                                                      "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${matchProvider.matches?[index].user2!.avatarProfile!.path}")
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
                                                      "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${matchProvider.matches?[index].user1!.avatarProfile!.path}")
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
                                                child: matchProvider
                                                            .matches![index]
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
                                                            if (matchProvider
                                                                .matches![index]
                                                                .messages!
                                                                .isNotEmpty)
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 3,
                                                                ),
                                                                child: Text(
                                                                  DateFormat("HH:mm").format(matchProvider
                                                                      .matches![
                                                                          index]
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
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                          .pinkAccent[
                                                                      400],
                                                                ),
                                                              ),
                                                            ),
                                                            if (matchProvider
                                                                .matches![index]
                                                                .messages!
                                                                .isNotEmpty)
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 3,
                                                                ),
                                                                child: Text(
                                                                  DateFormat("HH:mm").format(matchProvider
                                                                      .matches![
                                                                          index]
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
                                              margin: EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          right: 70),
                                                      margin: EdgeInsets.only(
                                                          bottom: 10),
                                                      child: matchProvider
                                                              .matches![index]
                                                              .messages!
                                                              .isNotEmpty
                                                          ? Row(
                                                              children: [
                                                                matchProvider
                                                                            .matches![
                                                                                index]
                                                                            .messages!
                                                                            .last
                                                                            .messageStatus ==
                                                                        MessageStatus
                                                                            .DELIVERED
                                                                    ? Icon(
                                                                        Icons
                                                                            .done_all,
                                                                        color: Colors
                                                                            .blueAccent,
                                                                      )
                                                                    : Icon(Icons
                                                                        .done),
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
