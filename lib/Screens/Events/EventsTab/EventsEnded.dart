import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsStatusProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsEnded extends StatefulWidget {
  EventsEnded({this.user});
  User? user;
  @override
  _EventsEndedState createState() => _EventsEndedState();
}

class _EventsEndedState extends State<EventsEnded> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<EventsStatusProvider>(context, listen: false)
          .getEventsByStatus(widget.user!.token!, EventStatus.ENDED);
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

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 15, right: 5, left: 5),
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
                                      Icons.sentiment_very_dissatisfied_sharp,
                                      size: 150,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "The list of ended events is empty",
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index]),
                              ),
                            ),
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
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
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
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 50),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                            child: Icon(Icons.close_outlined),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Text("Ended"),
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
                          height: MediaQuery.of(context).size.height,
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
                          return Container(
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 250,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.sentiment_very_dissatisfied_sharp,
                                      size: 150,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "The list of ended events is empty",
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index]),
                              ),
                            ),
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
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
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
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 50),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                            child: Icon(Icons.close_outlined),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Text("Ended"),
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
                          height: MediaQuery.of(context).size.height,
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
                          return Container(
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 200,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.sentiment_very_dissatisfied_sharp,
                                      size: 150,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "The list of ended events is empty",
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index]),
                              ),
                            ),
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
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
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
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 50),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                            child: Icon(Icons.close_outlined),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Text("Ended"),
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
                          height: MediaQuery.of(context).size.height,
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
                          return Container(
                            child: Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 100,
                                  ),
                                  Container(
                                    child: Icon(
                                      Icons.sentiment_very_dissatisfied_sharp,
                                      size: 150,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Text(
                                      "The list of ended events is empty",
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutEventScreen(
                                    event:
                                        eventsStatusProvider.eventData![index]),
                              ),
                            ),
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
                                          '${eventsStatusProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(eventsStatusProvider.eventData![index].endDate!) : "Without description"}',
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
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: 15, left: 50),
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
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
                                            child: Icon(Icons.close_outlined),
                                            margin: EdgeInsets.only(right: 10),
                                          ),
                                          Text("Ended"),
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
                          height: MediaQuery.of(context).size.height,
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
