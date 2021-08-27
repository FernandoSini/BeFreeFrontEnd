import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/EventsProvider.dart';
import 'package:be_free_v1/Providers/EventsStatusProvider.dart';
import 'package:be_free_v1/Providers/YourEventsProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:be_free_v1/Screens/Events/EditEvents/EditEventsScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class YourEvents extends StatefulWidget {
  YourEvents({this.user});
  User? user;
  @override
  _YourEventsState createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<YourEventsProvider>(context, listen: false)
            .getYourEvents(widget.user!.token!, widget.user!.id!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.pinkAccent[400],
        ),
        title: Text(
          "Click on event cart to update the event",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Segoe",
            fontSize: 15,
            color: Colors.pinkAccent[400],
          ),
        ),
      ),
      body: Container(
        child: Consumer<YourEventsProvider>(
          builder: (_, yourEventsProvider, __) {
            if (!yourEventsProvider.isLoading) {
              if (yourEventsProvider.eventData!.isEmpty) {
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
                  itemCount: yourEventsProvider.eventData?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditEventsScreen(
                                event: yourEventsProvider.eventData![index],
                                user: widget.user!),
                          ),
                        );
                      },
                      child: Container(
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
                                        image: yourEventsProvider
                                                    .eventData?[index]
                                                    .eventPhoto !=
                                                null
                                            ? NetworkImage(
                                                "http://192.168.0.22:3000/api/${yourEventsProvider.eventData?[index].eventPhoto?.path}")
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
                                        '${yourEventsProvider.eventData![index].startDate != null ? DateFormat("dd/MM/yyyy").format(yourEventsProvider.eventData![index].startDate!) : "Without date"}' +
                                        '  ' +
                                        'End Date: ' +
                                        '${yourEventsProvider.eventData![index].endDate != null ? DateFormat("dd/MM/yyyy").format(yourEventsProvider.eventData![index].endDate!) : "Without description"}',
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
                                    '${yourEventsProvider.eventData?[index].eventName ?? "Without description"}',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'Address: ${yourEventsProvider.eventData?[index].eventLocation ?? "Without address"}',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    '${yourEventsProvider.eventData?[index].users!.length ?? "Without users"} Going',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7)),
                                  ),
                                ),
                                if (yourEventsProvider
                                        .eventData![index].eventStatus ==
                                    EventStatus.ENDED)
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
                                  )
                                else
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, left: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                                child: Icon(Icons.done_outline),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                              ),
                                              Text("Going"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, right: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              yourEventsProvider.events
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
                                                child:
                                                    Icon(Icons.close_outlined),
                                                margin:
                                                    EdgeInsets.only(right: 10),
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
      ),
    );
  }
}
