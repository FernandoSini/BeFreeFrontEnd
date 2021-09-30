import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Screens/Events/EditEvents/EditEventsScreen.dart';
import 'package:be_free_v1/Screens/Events/EventsTab/EventsGoing.dart';
import 'package:be_free_v1/Screens/Events/EventsTab/EventsEnded.dart';
import 'package:be_free_v1/Screens/Events/EventsTab/EventsHappening.dart';
import 'package:be_free_v1/Screens/Events/EventsTab/YourEvents.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'EventsTab/EventsIncoming.dart';
import 'Search/SearchEventScreen.dart';

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
            color: Color(0xFF9a00e6),
          ),
        ),
        Container(
          child: Text(
            "Incoming",
            softWrap: true,
            style: TextStyle(color: Color(0xFF9a00e6), fontSize: 9),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_note_outlined,
          color: Color(0xFF9a00e6),
        ),
        Container(
          child: Text(
            "Happen",
            style: TextStyle(color: Color(0xFF9a00e6), fontSize: 10),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_available_outlined,
          color: Color(0xFF9a00e6),
        ),
        Container(
          child: Text(
            "Going",
            style: TextStyle(color: Color(0xFF9a00e6), fontSize: 10),
          ),
        )
      ],
    ),
    Column(
      children: [
        Icon(
          Icons.event_busy_outlined,
          color: Color(0xFF9a00e6),
        ),
        Container(
          child: Text(
            "Ended",
            style: TextStyle(color: Color(0xFF9a00e6), fontSize: 10),
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
            // fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            color: Colors.pinkAccent[400],
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchEventScreen(widget.user!),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.pinkAccent[400]),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => YourEvents(user: widget.user!),
                ),
              );
            },
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
          EventsGoing(
            user: widget.user,
          ),
          EventsEnded(
            user: widget.user,
          ),
        ],
      ),
    );
  }
}
