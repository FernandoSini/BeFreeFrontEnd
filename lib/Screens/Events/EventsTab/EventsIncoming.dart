import 'package:be_free_front/Models/Event.dart';
import 'package:be_free_front/Models/EventStatus.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/EventsProvider.dart';
import 'package:be_free_front/Providers/EventsStatusProvider.dart';
import 'package:flutter/material.dart';
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
      // margin: EdgeInsets.only(top: 15),
      child: Consumer<EventsStatusProvider>(
        builder: (_, eventsStatusProvider, __) {
          // print(eventsProvider.eventData?.first.eventStatus);
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
                          "Sorry, the list of incoming events is empty",
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
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width * 1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/avatars/avatar2.png"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10, left: 10),
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Start Date: ' +
                                    '${eventsStatusProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                    '  ' +
                                    'End Date: ' +
                                    '${eventsStatusProvider.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 15, left: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      // primary: Color(0xFF9a00e6),
                                      primary: Colors.blue,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  margin:
                                      EdgeInsets.only(bottom: 15, right: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
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
                          ],
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
    );
  }
}
