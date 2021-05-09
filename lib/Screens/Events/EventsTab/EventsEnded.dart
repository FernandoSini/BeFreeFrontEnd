import 'package:be_free_front/Models/EventStatus.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Providers/EventsStatusProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsEnded extends StatefulWidget {
  EventsEnded({this.user});
  User? user;
  @override
  _EventsEndedState createState() => _EventsEndedState();
}

class _EventsEndedState extends State<EventsEnded> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<EventsStatusProvider>(context, listen: false)
          .getEventsByStatus(widget.user!.token!, EventStatus.ENDED);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, right: 5, left: 5),
      child: Consumer<EventsStatusProvider>(
        builder: (_, eventStatusProvider, __) {
          if (!eventStatusProvider.isLoading) {
            if (eventStatusProvider.eventData!.isEmpty) {
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
              itemCount: eventStatusProvider.eventData?.length,
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
                        // 'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                        "${eventStatusProvider.eventData?[index].eventLocation}",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
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
