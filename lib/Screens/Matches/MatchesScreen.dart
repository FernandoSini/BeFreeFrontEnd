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
        title: Text(
          "Matches",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: Text("Your Matches"),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.red,
              alignment: Alignment.center,
              child: Consumer<MatchProvider>(
                builder: (context, matchProvider, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: matchProvider.matches?.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                user: matchProvider.matches?[index].hisHer,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: matchProvider
                                          .matches?[index].hisHer?.avatar !=
                                      null
                                  ? Image.network(
                                      "${matchProvider.matches?[index].hisHer!.avatar}",
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset("assets/avatars/avatar2.png"),
                            ),
                            // backgroundImage: matchProvider
                            //             .matches?[index].hisHer?.avatar !=
                            //         null
                            //     ? NetworkImage(
                            //         "${matchProvider.matches?[index].hisHer!.avatar}")
                            //     : AssetImage("assets/avatars/avatar2.png")
                            //         as ImageProvider,
                            // backgroundColor: Colors.transparent,
                            // minRadius: 10,
                            // maxRadius: 30,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.red,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      // color: Colors.black,
                      margin: EdgeInsets.only(
                        top: 30,
                        bottom: 30,
                        left: 20,
                      ),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        // color: Colors.blue,
                        child: Icon(
                          Icons.email,
                          size: 50,
                        ),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
