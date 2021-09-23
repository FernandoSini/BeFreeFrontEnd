import 'dart:convert';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/EventsStatusProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EventsHappening extends StatefulWidget {
  EventsHappening({this.user});
  User? user;
  @override
  _EventsHappeningState createState() => _EventsHappeningState();
}

class _EventsHappeningState extends State<EventsHappening> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<EventsStatusProvider>(context, listen: false)
            .getEventsByStatus(widget.user!.token!, EventStatus.HAPPENING);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<EventsStatusProvider>(context, listen: false).clear();
      }
    });
    super.dispose();
  }

  Future<void> goToEvent(String id, String token, String eventId) async {
    String? url = "${await storage.read(key: api.key)}api/events/$eventId/go";
    var data = {"yourId": id};
    var body = jsonEncode(data);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      print("você vai para o evento");
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10, right: 5, left: 5),
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
                  child: Consumer<EventsStatusProvider>(
                    builder: (_, eventsStatusProvider, __) {
                      if (!eventsStatusProvider.isLoading) {
                        if (eventsStatusProvider.eventData!.isEmpty) {
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
                                      "Sorry, the list of happening events is empty",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) => InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: eventsStatusProvider
                                                      .eventData?[index]
                                                      .eventPhoto !=
                                                  null
                                              ? NetworkImage(
                                                  "${api.url}api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
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
                                          '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                          '  ' +
                                          'End Date: ' +
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without date"}',
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
                                      '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  if (!eventsStatusProvider
                                      .eventData![index].users!
                                      .any(
                                          (user) => user.id == widget.user!.id))
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              goToEvent(
                                                  widget.user!.id!,
                                                  widget.user!.token!,
                                                  eventsStatusProvider
                                                      .eventData![index].id!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Going"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                eventsStatusProvider.eventData
                                                    ?.remove(
                                                        eventsStatusProvider
                                                            .eventData![index]);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF9a00e6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                      Icons.close_outlined),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Ignore"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 50, bottom: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF9a00e6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(Icons.done_outline),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text("Happening"),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                    bottom: 150,
                  ),
                  child: Consumer<EventsStatusProvider>(
                    builder: (_, eventsStatusProvider, __) {
                      if (!eventsStatusProvider.isLoading) {
                        if (eventsStatusProvider.eventData!.isEmpty) {
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
                                  "Sorry, the list of happening events is empty",
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) => InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: eventsStatusProvider
                                                      .eventData?[index]
                                                      .eventPhoto !=
                                                  null
                                              ? NetworkImage(
                                                  "${api.url}api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
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
                                          '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                          '  ' +
                                          'End Date: ' +
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without date"}',
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
                                      '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  if (!eventsStatusProvider
                                      .eventData![index].users!
                                      .any(
                                          (user) => user.id == widget.user!.id))
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              goToEvent(
                                                  widget.user!.id!,
                                                  widget.user!.token!,
                                                  eventsStatusProvider
                                                      .eventData![index].id!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Going"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                eventsStatusProvider.eventData
                                                    ?.remove(
                                                        eventsStatusProvider
                                                            .eventData![index]);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF9a00e6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                      Icons.close_outlined),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Ignore"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 50, bottom: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF9a00e6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(Icons.done_outline),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text("Happening"),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                    bottom: 150,
                  ),
                  child: Consumer<EventsStatusProvider>(
                    builder: (_, eventsStatusProvider, __) {
                      if (!eventsStatusProvider.isLoading) {
                        if (eventsStatusProvider.eventData!.isEmpty) {
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
                                  "Sorry, the list of happening events is empty",
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) => InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: eventsStatusProvider
                                                      .eventData?[index]
                                                      .eventPhoto !=
                                                  null
                                              ? NetworkImage(
                                                  "${api.url}api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
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
                                          '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                          '  ' +
                                          'End Date: ' +
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without date"}',
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
                                      '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  if (!eventsStatusProvider
                                      .eventData![index].users!
                                      .any((user) =>
                                          user.id == widget.user!.id!))
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              goToEvent(
                                                  widget.user!.id!,
                                                  widget.user!.token!,
                                                  eventsStatusProvider
                                                      .eventData![index].id!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Going"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                eventsStatusProvider.eventData
                                                    ?.remove(
                                                        eventsStatusProvider
                                                            .eventData![index]);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF9a00e6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                      Icons.close_outlined),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Ignore"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 50, bottom: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF9a00e6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(Icons.done_outline),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text("Happening"),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                  child: Consumer<EventsStatusProvider>(
                    builder: (_, eventsStatusProvider, __) {
                      if (!eventsStatusProvider.isLoading) {
                        if (eventsStatusProvider.eventData!.isEmpty) {
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
                                  "Sorry, the list of happening events is empty",
                                ),
                              ),
                            ],
                          );
                        }
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) => InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: eventsStatusProvider
                                                      .eventData?[index]
                                                      .eventPhoto !=
                                                  null
                                              ? NetworkImage(
                                                  "${api.url}api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
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
                                          '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                          '  ' +
                                          'End Date: ' +
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without date"}',
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
                                      '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  ),
                                  if (!eventsStatusProvider
                                      .eventData![index].users!
                                      .any((user) =>
                                          user.id == widget.user!.id!))
                                    ButtonBar(
                                      alignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              goToEvent(
                                                  widget.user!.id!,
                                                  widget.user!.token!,
                                                  eventsStatusProvider
                                                      .eventData![index].id!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Going"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, right: 10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                eventsStatusProvider.eventData
                                                    ?.remove(
                                                        eventsStatusProvider
                                                            .eventData![index]);
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFF9a00e6),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                      Icons.close_outlined),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Ignore"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 50, bottom: 15),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF9a00e6),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(Icons.done_outline),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text("Happening"),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
        ));
  }
}
