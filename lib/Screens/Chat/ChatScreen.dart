import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:be_free_v1/Models/Match.dart';
import 'package:be_free_v1/Models/Message.dart';
import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/MessagesProvider.dart';
import 'package:be_free_v1/Screens/Chat/component/YourMessageCard.dart';
import 'package:be_free_v1/Widget/FullScreenWidget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'component/ReplyCard.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.user, this.you, this.match});

  User? user;
  User? you;
  Match? match;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  StompClient? stompClient;
  TextEditingController controllerMessage = TextEditingController(text: "");
  ScrollController _scrollController = ScrollController();

  late IO.Socket socket;
  StreamController get controller => StreamController<Message>();

  void connect() {
    socket = IO.io("http://192.168.0.22:3000/match/chat",
        IO.OptionBuilder().setTransports(['websocket', 'polling']).build());
    socket.onConnect((data) {
      print("connected: " + socket.id! + " data: " + data.toString());
      // socket.on("sendMessage", (data) => print(data));
    });
    // socket.emit("sendMessage", message);
    socket.emit("signIn", widget.you!.id);
    socket.onError((data) => print("error:" + data.toString()));

    // socket.on("carregarData", (data) => print(data));
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    socket.on("sendMessage", (data) {
      Provider.of<MessagesProvider>(context, listen: false)
          .setMessages(Message.fromJson(data));
    });
  }

  @override
  void initState() {
    connect();
    loadMessages();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  void loadMessages() {
    socket.emit("loadMessages", widget.match!.matchId!);
    socket.on("carregarMensagens", (data) {
      print(data);
      if (Provider.of<MessagesProvider>(context, listen: false).messages !=
              null ||
          Provider.of<MessagesProvider>(context, listen: false)
              .messages!
              .isNotEmpty) {
        Provider.of<MessagesProvider>(context, listen: false).messages?.clear();
        data.forEach((element) {
          Provider.of<MessagesProvider>(context, listen: false)
              .setMessages(Message.fromJsonSocket(element));
        });
      } else {
        Provider.of<MessagesProvider>(context, listen: false).messages?.clear();
      }
    });
  }

  @override
  void dispose() {
    socket.onDisconnect((data) => print("disconnected"));
    socket.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        Provider.of<MessagesProvider>(context, listen: false).dispose();
      }
    });
    super.dispose();
  }

  Future<Message?> sendMessage(String yourId, String content, String targetId,
      String matchId, context) async {
    Message message = new Message(
        content: content,
        yourId: yourId,
        targetId: targetId,
        matchId: matchId,
        messageStatus: MessageStatus.RECEIVED,
        timestamp: DateTime.now());
    socket.emit("sendMessage", message.toJson());
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = context.watch<MessagesProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
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
                          child: widget.user?.avatarProfile != null
                              ? Image.network(
                                  "http://192.168.0.22:3000/api/${widget.user!.avatarProfile!.path!}",
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
                "${widget.user?.username}",
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
        child: Container(
          // color: Colors.green,
          child: SingleChildScrollView(
            // physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                if (messageProvider.isLoading)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                    ),
                  )
                else
                  Container(
                      // color: Colors.yellow,
                      height: defaultTargetPlatform == TargetPlatform.iOS
                          ? MediaQuery.of(context).size.height * 0.77
                          : MediaQuery.of(context).size.height * 0.79,
                      clipBehavior: Clip.none,
                      child: Container(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: messageProvider.messages?.length != null
                              ? messageProvider.messages!.length
                              : 0,
                          itemBuilder: (context, index) {
                            // print(messageProvider.messages?[16].content);
                            if (widget.you!.id ==
                                messageProvider.messages?[index].yourId) {
                              return YourMessageCard(
                                  content:
                                      messageProvider.messages?[index].content,
                                  timestamp: messageProvider
                                      .messages?[index].timestamp);
                            } else {
                              return ReplyCard(
                                  content:
                                      messageProvider.messages?[index].content,
                                  timestamp: messageProvider
                                      .messages?[index].timestamp);
                            }
                          },
                        ),
                      )
                      // decoration: BoxDecoration(color: Colors.green),
                      ),
                // const SizedBox(height: 20),
                Container(
                  margin: defaultTargetPlatform == TargetPlatform.android
                      ? EdgeInsets.only(left: 10, right: 10, top: 10)
                      : EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            maxLines: null,
                            autofocus: true,
                            controller: controllerMessage,
                            scrollPhysics: BouncingScrollPhysics(),
                            keyboardType: TextInputType.text,
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
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(left: 10),
                        child: FloatingActionButton(
                          isExtended: true,
                          child: Icon(Icons.send),
                          onPressed: () async {
                            if (controllerMessage.text.isNotEmpty) {
                              var message = await sendMessage(
                                  widget.you!.id!,
                                  controllerMessage.text,
                                  widget.user!.id!,
                                  widget.match!.matchId!,
                                  context);
                              messageProvider.setMessages(message);
                              controllerMessage.clear();
                            } else {
                              print("is empty");
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
        ),
      ),
    );
  }
}
