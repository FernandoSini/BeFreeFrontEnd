import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AboutEventScreen extends StatefulWidget {
  AboutEventScreen({@required this.event});
  Event? event;
  @override
  _AboutEventScreenState createState() => _AboutEventScreenState();
}

class _AboutEventScreenState extends State<AboutEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.pinkAccent[400],
        ),
        title: widget.event!.eventStatus! == EventStatus.ENDED
            ? Text(
                "This event already ended",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Segoe",
                  color: Colors.pinkAccent[400],
                ),
              )
            : Text(""),
      ),
      body: Container(
        //caso queiramos voltar com a tela de eventos parecida com o fb no lugar do
        //listview devemos usar singlechildscrollview com column
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.event?.eventPhoto == null
                      ? AssetImage("assets/avatars/avatar2.png")
                      : NetworkImage(
                              "http://192.168.0.22:3000/api/${widget.event!.eventPhoto!.path!}")
                          as ImageProvider,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 10),
              child: Text(
                "${widget.event!.eventName}",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Segoe",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9a00e6),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.pinkAccent[400],
                    size: 30,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    child: Text(
                      "${widget.event!.eventLocation != null ? widget.event!.eventLocation : "Without location"}",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                margin: EdgeInsets.only(top: 5, left: 20, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      color: Colors.pinkAccent[400],
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Container(
                      child: Text(
                        "${widget.event!.users!.length >= 1000 ? "${widget.event!.users!.length}" + "k users going" : "${widget.event!.users!.length}" + " user(s) going"}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, bottom: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.pinkAccent[400],
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    child: Text(
                      "${DateFormat("dd/MM/yyyy HH:mm:ss").format(widget.event!.startDate!)}",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_off_sharp,
                    color: Colors.pinkAccent[400],
                    size: 25,
                  ),
                  const SizedBox(width: 5),
                  Container(
                    child: Text(
                      "${DateFormat("dd/MM/yyyy HH:mm:ss").format(widget.event!.endDate!)}",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Divider(
                color: Color(0xFF9a00e6),
              ),
            ),
            if (widget.event!.eventDescription != null)
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10, left: 15, right: 10),
                    child: Text(
                      "Event Description",
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Segoe",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9a00e6)),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: widget.event!.eventDescription!.length >= 100
                        ? MediaQuery.of(context).size.height * 0.4
                        : MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.only(left: 15, right: 10),
                    child: Text(
                      widget.event!.eventDescription!.contains("")
                          ? "Don't have description"
                          : widget.event!.eventDescription!,
                      softWrap: true,
                    ),
                  ),
                ],
              )
            else
              Container(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 15, right: 10),
              child: Text(
                "Who created this event",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Segoe",
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9a00e6),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Text("${widget.event!.eventOwner?.username}"),
                  ),
                  Container(
                    child: CircleAvatar(
                      backgroundImage: widget
                                  .event?.eventOwner?.avatarProfile !=
                              null
                          ? NetworkImage(
                              "http://192.168.0.22:3000/api/${widget.event!.eventOwner!.avatarProfile!.path}")
                          : AssetImage("assets/avatars/avatar2.png")
                              as ImageProvider,
                      radius: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
