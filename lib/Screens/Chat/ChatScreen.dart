import 'dart:convert';

import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Widget/FullScreenWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.user, this.you});
  User? user;
  User? you;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StompClient? stompClient;

  void onConnect(StompFrame frame) {
    if (stompClient != null) {
      print("aqui1");
      stompClient!.subscribe(
        destination: "/user/${widget.user?.idUser}",
        callback: (StompFrame frame) {
          print("connected");
          if (frame.body != null) {
            Map<String, dynamic> result = jsonDecode(frame.body!);
            print(result);
            // setState(() {
            //   message = result["name"];
            // });
          }
        },
      );
    }
  }

  TextEditingController controllerMessage = TextEditingController(text: "");

  void onSend(StompClient client, String text) {
    Map<String, dynamic> message = {
      "sender": widget.you?.toJson(),
      "receiver": widget.user?.toJson(),
      "content": text,
      "timestamp": DateTime.now(),
    };
    print("caindo aqui");
    client.send(destination: "/app/api/chat/send", body: json.encode(message));
  }

  String socketUrl = "http://10.0.2.2:8080/ws";
  @override
  void initState() {
    super.initState();
    if (stompClient != null) {
      print("aqui");
      stompClient = StompClient(
        config: StompConfig.SockJS(
          url: socketUrl,
          onConnect: onConnect,
          onWebSocketError: (dynamic error) => print(error),
        ),
      );
      stompClient!.activate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
        /*  title: Text(
          "${user?.userName}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Segoe",
            color: Color(0xFF9a00e6),
          ),
        ), */

        title: Row(
          children: [
            Container(
              child: CircleAvatar(
                radius: 23,
                child: Container(
                  child: FullScreenWidget(
                    child: Center(
                      child: Hero(
                        tag: "smallImage",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: widget.user?.avatar != null
                              ? Image.network(
                                  widget.user!.avatar!,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                )
                              : Image.asset("assets/avatars/avatar2.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                /*  backgroundImage:
                    NetworkImage(userManagerStore.user.avatar ?? defaultImage),
                radius: 20, */
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "${widget.user?.userName}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Segoe",
                  color: Colors.pinkAccent[400],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // color: Colors.red,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.8,
              clipBehavior: Clip.none,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: [
                  Text("maconha"),
                ],
              ),
              // decoration: BoxDecoration(color: Colors.green),
            ),
            // const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        maxLines: null,
                        scrollPhysics: BouncingScrollPhysics(),
                        decoration: InputDecoration(
                          hintText: "Message",
                          contentPadding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 15,
                            right: 15,
                          ),
                          // labelText: "Message",
                          // counterStyle: TextStyle(
                          //   color: Color(0xff9a00e6),
                          // ),
                          // labelStyle: TextStyle(
                          //   color: Color(0xff9a00e6),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          // hintText: "Password",
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 5,
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          print(value);
                          controllerMessage.text = value;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: FloatingActionButton(
                      isExtended: true,
                      child: Icon(Icons.send),
                      onPressed: () {
                        print(controllerMessage.text);
                        if (stompClient != null) {
                          onSend(stompClient!, controllerMessage.text);
                          controllerMessage.text = "";
                        }
                      },
                      backgroundColor: Color(0xff9a00e6),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
