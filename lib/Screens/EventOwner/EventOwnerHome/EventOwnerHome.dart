import 'package:be_free_v1/Models/EventOwner.dart';
import 'package:be_free_v1/Providers/EventOwnerProvider.dart';
import 'package:be_free_v1/Providers/YourEventsProvider.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class EventOwnerHome extends StatefulWidget {
  EventOwnerHome({this.eventOwner});
  EventOwner? eventOwner;

  @override
  _EventOwnerHomeState createState() => _EventOwnerHomeState();
}

class _EventOwnerHomeState extends State<EventOwnerHome> {
  final storage = new FlutterSecureStorage();

  void _logout(context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      await storage.deleteAll();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
    /* else {
      universal.window.sessionStorage.clear();
      universal.window.localStorage.clear();

      // localStorage.clear();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } */
    // Provider.of<ListUsersProvider>(context).dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        if (mounted) {
          await Provider.of<YourEventsProvider>(context, listen: false)
              .getYourEvents(
                  widget.eventOwner!.token!, widget.eventOwner!.eventOwnerId!);
        }

        if (JwtDecoder.isExpired(widget.eventOwner!.token!)) {
          await storage.deleteAll();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        }
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        if (JwtDecoder.isExpired(widget.eventOwner!.token!)) {
          await storage.deleteAll();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !(defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                "BeFree",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Color(0xFF9a00e6),
                  fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                      ? 30
                      : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                GestureDetector(
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
                          foregroundImage:
                              widget.eventOwner?.avatarProfile != null
                                  ? NetworkImage(
                                      "${widget.eventOwner?.avatarProfile!.url}",
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
                        "${widget.eventOwner?.eventOwnerName}",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF9a00e6)),
                      )
                    ],
                  ),
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
              title: Text(
                /* userProvider.user?.userName != null
                        ? "Welcome ${userProvider.user?.userName}"
                        : */
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
      body: Container(
        margin: EdgeInsets.only(top: 10, right: 5, left: 5),
        child: Consumer<YourEventsProvider>(
          builder: (_, yourEvents, __) {
            if (!yourEvents.isLoading) {
              if (yourEvents.eventData!.isEmpty) {
                return Container(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 250,
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
                            "Sorry, the list of your events is empty",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: yourEvents.eventData?.length,
                itemBuilder: (context, index) => Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/avatars/avatar2.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Start Date: ' +
                              '${yourEvents.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                              '  ' +
                              'End Date: ' +
                              '${yourEvents.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${yourEvents.eventData?[index].eventName ?? "Without description"}',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Address: ${yourEvents.eventData?[index].eventLocation ?? "Without address"}',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${yourEvents.eventData?[index].users!.length ?? "Without users"} Going',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 10),
                      //   padding: const EdgeInsets.all(5.0),
                      //   child: Text(
                      //     'Start Date: ${eventsStatusProvider.eventData?[index].startDate.toString().substring(0, 10) ?? "Without date"}',
                      //     style: TextStyle(
                      //         color: Colors.black.withOpacity(0.7)),
                      //   ),
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 10),
                      //   padding: const EdgeInsets.all(5.0),
                      //   child: Text(
                      //     'End Date: ${eventsStatusProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}',
                      //     style: TextStyle(
                      //       color: Colors.black.withOpacity(0.7),
                      //     ),
                      //   ),
                      // ),
                      // ButtonBar(
                      //   alignment: MainAxisAlignment.start,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {
                      //         // Perform some action
                      //       },
                      //       child: const Text('ACTION 1'),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         // Perform some action
                      //       },
                      //       child: const Text('ACTION 2'),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF9a00e6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.done_outline),
                                margin: EdgeInsets.only(right: 10),
                              ),
                              Text("Happening"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}
