import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/EventsStatusProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsIncoming extends StatefulWidget {
  EventsIncoming({this.user});
  User? user;
  @override
  _EventsIncomingState createState() => _EventsIncomingState();
}

class _EventsIncomingState extends State<EventsIncoming> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<EventsStatusProvider>(context, listen: false)
            .getEventsByStatus(widget.user!.token!, EventStatus.INCOMING);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (Responsive.isTooLargeScreen(context))
              Container(
                height: MediaQuery.of(context).size.height,
                child: Consumer<EventsStatusProvider>(
                  builder: (_, eventsStatusProvider, __) {
                    if (!eventsStatusProvider.isLoading) {
                      if (eventsStatusProvider.eventData!.isEmpty) {
                        return Column(
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
                                "Sorry, the list of incoming events is empty",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AboutEventScreen(
                                      event: eventsStatusProvider
                                          .eventData![index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: eventsStatusProvider
                                                            .eventData?[index]
                                                            .eventPhoto !=
                                                        null
                                                    ? NetworkImage(
                                                        "http://192.168.0.22:3000/api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Start Date: ' +
                                                '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                                '  ' +
                                                'End Date: ' +
                                                '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          Icons.done_outline),
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
                                                    eventsStatusProvider.events
                                                        ?.removeAt(index);
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
                child: Consumer<EventsStatusProvider>(
                  builder: (_, eventsStatusProvider, __) {
                    if (!eventsStatusProvider.isLoading) {
                      if (eventsStatusProvider.eventData!.isEmpty) {
                        return Column(
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
                                "Sorry, the list of incoming events is empty",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AboutEventScreen(
                                      event: eventsStatusProvider
                                          .eventData![index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: eventsStatusProvider
                                                            .eventData?[index]
                                                            .eventPhoto !=
                                                        null
                                                    ? NetworkImage(
                                                        "http://192.168.0.22:3000/api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Start Date: ' +
                                                '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                                '  ' +
                                                'End Date: ' +
                                                '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          Icons.done_outline),
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
                                                    eventsStatusProvider.events
                                                        ?.removeAt(index);
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
                                "Sorry, the list of incoming events is empty",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AboutEventScreen(
                                      event: eventsStatusProvider
                                          .eventData![index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: eventsStatusProvider
                                                            .eventData?[index]
                                                            .eventPhoto !=
                                                        null
                                                    ? NetworkImage(
                                                        "http://192.168.0.22:3000/api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Start Date: ' +
                                                '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                                '  ' +
                                                'End Date: ' +
                                                '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          Icons.done_outline),
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
                                                    eventsStatusProvider.events
                                                        ?.removeAt(index);
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
                                "Sorry, the list of incoming events is empty",
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: eventsStatusProvider.eventData?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => AboutEventScreen(
                                      event: eventsStatusProvider
                                          .eventData![index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(top: 10, left: 5, right: 5),
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
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: eventsStatusProvider
                                                            .eventData?[index]
                                                            .eventPhoto !=
                                                        null
                                                    ? NetworkImage(
                                                        "http://192.168.0.22:3000/api/${eventsStatusProvider.eventData?[index].eventPhoto?.path}")
                                                    : AssetImage(
                                                            "assets/avatars/avatar2.png")
                                                        as ImageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Start Date: ' +
                                                '${eventsStatusProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].startDate!) : "Without date"}' +
                                                '  ' +
                                                'End Date: ' +
                                                '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].eventName ?? "Without description"}',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            'Address: ${eventsStatusProvider.eventData?[index].eventLocation ?? "Without address"}',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                          ),
                                        ),
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blue,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      child: Icon(
                                                          Icons.done_outline),
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
                                                bottom: 15,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    eventsStatusProvider.events
                                                        ?.removeAt(index);
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
