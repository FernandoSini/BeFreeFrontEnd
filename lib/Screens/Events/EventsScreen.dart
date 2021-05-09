import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Events/EventsTab/EventsGoing.dart';
import 'package:be_free_front/Screens/Events/EventsTab/EventsEnded.dart';
import 'package:be_free_front/Screens/Events/EventsTab/EventsHappening.dart';
import 'package:flutter/material.dart';

import 'EventsTab/EventsIncoming.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({this.user});
  User? user;
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  List<Widget> tabs = [
    Column(
      children: [
        Container(
          child: Icon(
            Icons.event_outlined,
            color: Colors.pink[400],
          ),
        ),
        Container(
          child: Text(
            "Incoming",
            softWrap: true,
            style: TextStyle(color: Colors.pink[400], fontSize: 9),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_note_outlined,
          color: Colors.pink[400],
        ),
        Container(
          child: Text(
            "Happening",
            style: TextStyle(color: Colors.pink[400], fontSize: 10),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_available_outlined,
          color: Colors.pink[400],
        ),
        Container(
          child: Text(
            "Going",
            style: TextStyle(color: Colors.pink[400], fontSize: 10),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_busy_outlined,
          color: Colors.pink[400],
        ),
        Container(
          child: Text(
            "Ended",
            style: TextStyle(color: Colors.pink[400], fontSize: 10),
          ),
        )
      ],
    ),
  ];

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Events",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pink[400],
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.more_vert_outlined,
            color: Color(0xFF9a00e6),
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            color: Color(0xFF9a00e6),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(controller: tabController, tabs: tabs),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          EventsIncoming(
            user: widget.user,
          ),
          EventsHappening(
            user: widget.user,
          ),
          EventsGoing(),
          EventsEnded(
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
