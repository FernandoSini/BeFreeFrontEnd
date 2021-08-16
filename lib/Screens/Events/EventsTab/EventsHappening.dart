import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/EventsStatusProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventsHappening extends StatefulWidget {
  EventsHappening({this.user});
  User? user;
  @override
  _EventsHappeningState createState() => _EventsHappeningState();
}

class _EventsHappeningState extends State<EventsHappening> {
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 5, left: 5),
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
                        event: eventsStatusProvider.eventData![index],
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
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.7)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${eventsStatusProvider.eventData?[index].users!.length ?? "Without users"} Going',
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
                      if (!eventsStatusProvider.eventData![index].users!
                          .contains(widget.user))
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 15, left: 10),
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  // primary: Color(0xFF9a00e6),
                                  primary: Colors.blue,
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
                            Container(
                              margin: EdgeInsets.only(bottom: 15, right: 10),
                              width: MediaQuery.of(context).size.width * 0.42,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    eventsStatusProvider.eventData?.remove(
                                        eventsStatusProvider.eventData![index]);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF9a00e6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Icon(Icons.close_outlined),
                                      margin: EdgeInsets.only(right: 10),
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
    );
  }
}
