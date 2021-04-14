import 'package:be_free_front/Screens/Events/EventsTab/EventsGoing.dart';
import 'package:be_free_front/Screens/Events/EventsTab/EventsIgnored.dart';
import 'package:flutter/material.dart';

import 'EventsTab/EventsIncoming.dart';

class EventsScreen extends StatefulWidget {
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
            Icons.event,
            color: Colors.pink[400],
          ),
        ),
        Container(
          child: Text(
            "Events incoming",
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
            "Events ignored",
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
        controller: tabController,
        children: [
          EventsIncoming(),
          EventsGoing(),
          EventsIgnored(),
        ],
      ),
    );
  }
}
