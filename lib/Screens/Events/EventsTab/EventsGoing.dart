import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsGoingProvider.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class EventsGoing extends StatefulWidget {
  EventsGoing({this.user});
  User? user;
  @override
  _EventsGoingState createState() => _EventsGoingState();
}

class _EventsGoingState extends State<EventsGoing> {
  final storage = new FlutterSecureStorage();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<EventsGoingProvider>(context, listen: false)
            .getEventsByStatus(widget.user!.token!, widget.user!.id!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        Provider.of<EventsGoingProvider>(context, listen: false).dispose();
        if (JwtDecoder.isExpired(widget.user!.token!)) {
          await storage.deleteAll();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 15, left: 5, right: 5),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            if (Responsive.isTooLargeScreen(context))
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  bottom: 150,
                ),
                child: Consumer<EventsGoingProvider>(
                  builder: (context, eventsGoingProvider, child) {
                    if (!eventsGoingProvider.isLoading) {
                      if (eventsGoingProvider.eventData!.isEmpty) {
                        return Container(
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 240,
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
                                    "You are not going to any event",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: eventsGoingProvider.eventData?.length,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: eventsGoingProvider
                                                  .eventData?[index]
                                                  .eventPhoto !=
                                              null
                                          ? NetworkImage(
                                              "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${eventsGoingProvider.eventData?[index].eventPhoto?.path}")
                                          : AssetImage(
                                                  "assets/avatars/avatar2.png")
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Start Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                      '  ' +
                                      'End Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                                  '${eventsGoingProvider.eventData?[index].eventName ?? "Without description"}',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Address: ${eventsGoingProvider.eventData?[index].eventLocation ?? "Without address"}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${eventsGoingProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15, left: 50),
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
                                      Text("Going"),
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
              )
            else if (Responsive.isLargeScreen(context))
              Container(
                padding: EdgeInsets.only(
                  bottom: 150,
                ),
                height: MediaQuery.of(context).size.height,
                child: Consumer<EventsGoingProvider>(
                  builder: (context, eventsGoingProvider, child) {
                    if (!eventsGoingProvider.isLoading) {
                      if (eventsGoingProvider.eventData!.isEmpty) {
                        return Container(
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 240,
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
                                    "You are not going to any event",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: eventsGoingProvider.eventData?.length,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: eventsGoingProvider
                                                  .eventData?[index]
                                                  .eventPhoto !=
                                              null
                                          ? NetworkImage(
                                              "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${eventsGoingProvider.eventData?[index].eventPhoto?.path}")
                                          : AssetImage(
                                                  "assets/avatars/avatar2.png")
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Start Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                      '  ' +
                                      'End Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                                  '${eventsGoingProvider.eventData?[index].eventName ?? "Without description"}',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Address: ${eventsGoingProvider.eventData?[index].eventLocation ?? "Without address"}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${eventsGoingProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15, left: 50),
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
                                      Text("Going"),
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
              )
            else if (Responsive.isMediumScreen(context))
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    bottom:
                        150), //essa linha evitou que o card ficasse embaixo do bottom navigation bar
                child: Consumer<EventsGoingProvider>(
                  builder: (context, eventsGoingProvider, child) {
                    if (!eventsGoingProvider.isLoading) {
                      if (eventsGoingProvider.eventData!.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 200,
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
                                "You are not going to any event",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: eventsGoingProvider.eventData?.length,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: eventsGoingProvider
                                                  .eventData?[index]
                                                  .eventPhoto !=
                                              null
                                          ? NetworkImage(
                                              "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${eventsGoingProvider.eventData?[index].eventPhoto?.path}")
                                          : AssetImage(
                                                  "assets/avatars/avatar2.png")
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Start Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                      '  ' +
                                      'End Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                                  '${eventsGoingProvider.eventData?[index].eventName ?? "Without description"}',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Address: ${eventsGoingProvider.eventData?[index].eventLocation ?? "Without address"}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${eventsGoingProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15, left: 50),
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
                                      Text("Going"),
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
              )
            else
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  bottom: 150,
                ),
                child: Consumer<EventsGoingProvider>(
                  builder: (context, eventsGoingProvider, child) {
                    if (!eventsGoingProvider.isLoading) {
                      if (eventsGoingProvider.eventData!.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 100,
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
                                "You are not going to any event",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: eventsGoingProvider.eventData?.length,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width * 1,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: eventsGoingProvider
                                                  .eventData?[index]
                                                  .eventPhoto !=
                                              null
                                          ? NetworkImage(
                                              "http://${dotenv.env["url"]}:${dotenv.env["port"]}/api/${eventsGoingProvider.eventData?[index].eventPhoto?.path}")
                                          : AssetImage(
                                                  "assets/avatars/avatar2.png")
                                              as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Start Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                      '  ' +
                                      'End Date: ' +
                                      '${eventsGoingProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                                  '${eventsGoingProvider.eventData?[index].eventName ?? "Without description"}',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'Address: ${eventsGoingProvider.eventData?[index].eventLocation ?? "Without address"}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${eventsGoingProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 15, left: 50),
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
                                      Text("Going"),
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
              )
          ],
        ),
      ),
    );
  }
}
