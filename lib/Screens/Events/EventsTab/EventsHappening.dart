import 'package:be_free_front/Models/EventStatus.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/EventsProvider.dart';
import 'package:be_free_front/Providers/EventsStatusProvider.dart';
import 'package:flutter/material.dart';
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
      await Provider.of<EventsStatusProvider>(context, listen: false)
          .getEventsByStatus(widget.user!.token!, EventStatus.HAPPENING);
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${eventsStatusProvider.eventData?[index].eventName}',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
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
    );
  }
}
