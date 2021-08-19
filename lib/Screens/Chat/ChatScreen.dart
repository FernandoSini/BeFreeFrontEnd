import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:be_free_v1/Models/Match.dart';
import 'package:be_free_v1/Models/Message.dart';
import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/MessagesProvider.dart';
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

  @override
  void initState() {
    socket = IO.io("http://192.168.0.22:3000/match/chat",
        IO.OptionBuilder().setTransports(['websocket', 'polling']).build());

    socket.onConnect((data) =>
        print("connected: " + socket.id! + " data: " + data.toString()));
    // socket.emit("sendMessage", message);
    socket.emit("signIn", widget.you!.id);
    socket.onError((data) => print("error:" + data.toString()));
    super.initState();
  }

  @override
  void dispose() {
    socket.onDisconnect((data) => print("disconnected"));
    socket.dispose();
    super.dispose();
  }

  Future<void> sendMessage(
      String yourId, String content, String targetId, String matchId) async {
    var message = {
      "yourId": yourId,
      "content": content,
      "targetId": targetId,
      "matchId": matchId,
      "message_status": EnumToString.convertToString(MessageStatus.RECEIVED),
      "timestamp": DateTime.now().toString()
    };
    socket.emit("sendMessage", message);
  }

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessagesProvider>(context);
    return Scaffold(
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
                            Color color =
                                Colors.purple.shade600.withOpacity(0.7);
                            Alignment alignment = Alignment.centerRight;
                            if (widget.you!.id ==
                                messageProvider.messages?[index].yourId!) {
                              alignment = Alignment.centerLeft;
                              color = Colors.lightBlue.withOpacity(0.5);
                            }

                            //interface de mensagens
                            return Align(
                              //alinhamentos
                              alignment: alignment,
                              //espaçamento entre os itens
                              child: Padding(
                                padding: EdgeInsets.all(6),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: //verificando se o item for do tipo texto edntro do child vai gcarregar o text se não vai carregar a imagem
                                      messageProvider
                                                  .messages![index].content !=
                                              null
                                          ? Text(
                                              messageProvider
                                                  .messages![index].content!,
                                              style: TextStyle(fontSize: 15),
                                            )
                                          : Text(""),
                                ),
                              ),
                            );

                            // return Container(
                            //   // height: 300,
                            //   color: Colors.pink,
                            //   width: MediaQuery.of(context).size.width * 0.5,
                            //   child: Text(
                            //       "${messageProvider.messages?[index].content}"),
                            // );
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
                            // autofocus: true,
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
                          onPressed: () {
                            sendMessage(widget.you!.id!, controllerMessage.text,
                                widget.user!.id!, widget.match!.matchId!);
                            controllerMessage.clear();
                            // onSend(controllerMessage.text);
                            // setState(() {
                            //   controllerMessage.clear();
                            // });
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
//
// // import 'dart:async';
// // import 'dart:convert';
//
// // import 'package:be_free_v1/Models/Match.dart';
// // import 'package:be_free_v1/Models/Message.dart';
// // import 'package:be_free_v1/Models/User.dart';
// // import 'package:be_free_v1/Providers/MessagesProvider.dart';
// // import 'package:be_free_v1/Widget/FullScreenWidget.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:stomp_dart_client/stomp.dart';
// // import 'package:stomp_dart_client/stomp_config.dart';
// // import 'package:stomp_dart_client/stomp_frame.dart';
//
// // class ChatScreen extends StatefulWidget {
// //   ChatScreen({this.user, this.you, this.match});
// //   User? user;
// //   User? you;
// //   Match? match;
//
// //   @override
// //   _ChatScreenState createState() => _ChatScreenState();
// // }
//
// // class _ChatScreenState extends State<ChatScreen> {
// //   StompClient? stompClient;
// //   TextEditingController controllerMessage = TextEditingController(text: "");
// //   ScrollController _scrollController = ScrollController();
// //   String socketUrl = "http://192.168.0.22:8080/socket";
// //   void onConnect(StompFrame frame) {
// //     if (stompClient != null) {
// //       stompClient!.subscribe(
// //         headers: {
// //           "Authorization": "Bearer ${widget.you!.token}",
// //           'Connection': 'upgrade',
// //           'Upgrade': 'websocket'
// //         },
// //         destination: "/user/${widget.user!.idUser}/queue/messages",
// //         callback: (frame) {
// //           print("connected");
// //           if (frame.body != null) {
// //             Map<String, dynamic> result = jsonDecode(frame.body!);
// //             print(result);
// //             // setState(() {
// //             //   message = result["name"];
// //             // });
// //           }
// //         },
// //       );
// //     } else {
// //       print("cant connect");
// //     }
// //   }
//
// //   void onSend(StompClient client, String text) {
// //     // Map<String, dynamic> message = {
// //     //   "sender": widget.you?.toJson(),
// //     //   "receiver": widget.user?.toJson(),
// //     //   "content": text,
// //     //   "timestamp":
// //     //       DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()).toString(),
// //     // };
// //     Message message = Message(
// //         sender: widget.you!,
// //         receiver: widget.user,
// //         content: text,
// //         // timestamp: new DateFormat("dd-MM-yyyy HH:mm:ss")
// //         //     .parse(DateTime.now().toString()),
// //         timestamp: DateTime.now());
// //     client.send(
// //       headers: {"Authorization": "Bearer ${widget.you!.token}"},
// //       destination: "/app/send",
// //       body: json.encode(
// //         message.toJson(),
// //       ),
// //     );
// //   }
//
// //   @override
// //   void initState() {
// //     WidgetsBinding.instance!.addPostFrameCallback((_) async {
// //       await Provider.of<MessagesProvider>(context, listen: false)
// //           .getMessages(
// //               widget.you!.token!, widget.you!.idUser!, widget.user!.idUser!)
// //           .then((value) {
// //         Timer(Duration(seconds: 1), () {
// //           _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
// //         });
// //       });
// //     });
// //     super.initState();
// //     stompClient = StompClient(
// //       config: StompConfig.SockJS(
// //         url: socketUrl,
// //         // useSockJS: true,
// //         onConnect: onConnect,
// //         beforeConnect: () async {
// //           print('waiting to connect...');
// //           await Future.delayed(Duration(milliseconds: 200));
// //           print('connecting...');
// //         },
// //         onWebSocketError: (dynamic error) => print(error.toString()),
// //         stompConnectHeaders: {
// //           'Authorization': 'Bearer ${widget.you!.token}',
// //           'Connection': 'upgrade',
// //           'Upgrade': 'websocket'
// //         },
// //         webSocketConnectHeaders: {
// //           'Authorization': 'Bearer ${widget.you!.token}',
// //           'Connection': 'upgrade',
// //           'Upgrade': 'websocket'
// //         },
// //       ),
// //     );
// //     stompClient!.activate();
// //   }
//
// //   @override
// //   void dispose() {
// //     stompClient!.deactivate();
// //     super.dispose();
// //   }
//
// //   void setText(String text) {
// //     setState(() {
// //       controllerMessage.text = text;
// //     });
// //   }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     final messageProvider = Provider.of<MessagesProvider>(context);
// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: Colors.transparent,
// //         centerTitle: true,
// //         actions: [],
// //         iconTheme: IconThemeData(
// //           color: Color(0xFF9a00e6),
// //         ),
// //         title: Row(
// //           children: [
// //             Container(
// //               child: CircleAvatar(
// //                 radius: 23,
// //                 child: Container(
// //                   child: FullScreenWidget(
// //                     child: Center(
// //                       child: Hero(
// //                         tag: "smallImage",
// //                         child: ClipRRect(
// //                           borderRadius: BorderRadius.circular(30),
// //                           child: widget.user?.avatarProfile != null
// //                               ? Image.network(
// //                                   widget.user!.avatarProfile!.url!,
// //                                   fit: BoxFit.cover,
// //                                   height:
// //                                       MediaQuery.of(context).size.height * 0.5,
// //                                   width:
// //                                       MediaQuery.of(context).size.width * 0.95,
// //                                 )
// //                               : Image.asset("assets/avatars/avatar2.png"),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 /*  backgroundImage:
// //                     NetworkImage(userManagerStore.user.avatar ?? defaultImage),
// //                 radius: 20, */
// //               ),
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 border: Border.all(color: Colors.white, width: 2),
// //               ),
// //             ),
// //             const SizedBox(
// //               width: 10,
// //             ),
// //             Container(
// //               margin: EdgeInsets.only(left: 10),
// //               child: Text(
// //                 "${widget.user?.userName}",
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontFamily: "Segoe",
// //                   color: Colors.pinkAccent[400],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       body: Container(
// //         height: MediaQuery.of(context).size.height,
// //         child: Container(
// //           // color: Colors.green,
// //           child: SingleChildScrollView(
// //             // physics: BouncingScrollPhysics(),
// //             child: Column(
// //               children: [
// //                 if (messageProvider.isLoading)
// //                   Container(
// //                     height: MediaQuery.of(context).size.height,
// //                     alignment: Alignment.center,
// //                     child: CircularProgressIndicator(
// //                       valueColor: AlwaysStoppedAnimation(Colors.purple),
// //                     ),
// //                   )
// //                 else
// //                   Container(
// //                       // color: Colors.yellow,
// //                       height: defaultTargetPlatform == TargetPlatform.iOS
// //                           ? MediaQuery.of(context).size.height * 0.77
// //                           : MediaQuery.of(context).size.height * 0.79,
// //                       clipBehavior: Clip.none,
// //                       child: Container(
// //                         child: ListView.builder(
// //                           controller: _scrollController,
// //                           physics: BouncingScrollPhysics(),
// //                           itemCount: messageProvider.messages?.length != null
// //                               ? messageProvider.messages!.length
// //                               : 0,
// //                           itemBuilder: (context, index) {
// //                             Color color =
// //                                 Colors.purple.shade600.withOpacity(0.7);
// //                             Alignment alignment = Alignment.centerRight;
// //                             if (widget.you!.idUser ==
// //                                 messageProvider
// //                                     .messages?[index].sender!.idUser) {
// //                               alignment = Alignment.centerLeft;
// //                               color = Colors.lightBlue.withOpacity(0.5);
// //                             }
//
// //                             //interface de mensagens
// //                             return Align(
// //                               //alinhamentos
// //                               alignment: alignment,
// //                               //espaçamento entre os itens
// //                               child: Padding(
// //                                 padding: EdgeInsets.all(6),
// //                                 child: Container(
// //                                   width:
// //                                       MediaQuery.of(context).size.width * 0.8,
// //                                   padding: EdgeInsets.all(16),
// //                                   decoration: BoxDecoration(
// //                                       color: color,
// //                                       borderRadius:
// //                                           BorderRadius.all(Radius.circular(8))),
// //                                   child: //verificando se o item for do tipo texto edntro do child vai gcarregar o text se não vai carregar a imagem
// //                                       messageProvider
// //                                                   .messages![index].content !=
// //                                               null
// //                                           ? Text(
// //                                               messageProvider
// //                                                   .messages![index].content!,
// //                                               style: TextStyle(fontSize: 15),
// //                                             )
// //                                           : Text(""),
// //                                 ),
// //                               ),
// //                             );
//
// //                             // return Container(
// //                             //   // height: 300,
// //                             //   color: Colors.pink,
// //                             //   width: MediaQuery.of(context).size.width * 0.5,
// //                             //   child: Text(
// //                             //       "${messageProvider.messages?[index].content}"),
// //                             // );
// //                           },
// //                         ),
// //                       )
// //                       // decoration: BoxDecoration(color: Colors.green),
// //                       ),
// //                 // const SizedBox(height: 20),
// //                 Container(
// //                   margin: defaultTargetPlatform == TargetPlatform.android
// //                       ? EdgeInsets.only(left: 10, right: 10, top: 10)
// //                       : EdgeInsets.only(left: 10, right: 10, top: 10),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.end,
// //                     children: [
// //                       Expanded(
// //                         child: Container(
// //                           child: TextFormField(
// //                             maxLines: null,
// //                             // autofocus: true,
// //                             controller: controllerMessage,
// //                             scrollPhysics: BouncingScrollPhysics(),
// //                             keyboardType: TextInputType.text,
// //                             decoration: InputDecoration(
// //                               hintText: "Message",
// //                               contentPadding: EdgeInsets.only(
// //                                 top: 10,
// //                                 bottom: 10,
// //                                 left: 15,
// //                                 right: 15,
// //                               ),
// //                               // labelText: "Message",
// //                               // counterStyle: TextStyle(
// //                               //   color: Color(0xff9a00e6),
// //                               // ),
// //                               // labelStyle: TextStyle(
// //                               //   color: Color(0xff9a00e6),
// //                               // ),
// //                               // border: OutlineInputBorder(
// //                               //   borderRadius: BorderRadius.circular(15),
// //                               // ),
// //                               enabledBorder: OutlineInputBorder(
// //                                 borderRadius: BorderRadius.circular(30),
// //                                 borderSide: BorderSide(
// //                                   color: Colors.black,
// //                                 ),
// //                               ),
// //                               // hintText: "Password",
// //                               focusedBorder: OutlineInputBorder(
// //                                 gapPadding: 5,
// //                                 borderRadius: BorderRadius.circular(30),
// //                                 borderSide: BorderSide(
// //                                   width: 2,
// //                                   color: Colors.blue,
// //                                 ),
// //                               ),
// //                             ),
// //                             onChanged: (value) {},
// //                           ),
// //                         ),
// //                       ),
// //                       Container(
// //                         color: Colors.transparent,
// //                         margin: EdgeInsets.only(left: 10),
// //                         child: FloatingActionButton(
// //                           isExtended: true,
// //                           child: Icon(Icons.send),
// //                           onPressed: (controllerMessage.text == "" ||
// //                                   controllerMessage.text.isEmpty)
// //                               ? null
// //                               : () {
// //                                   if (stompClient != null) {
// //                                     onSend(
// //                                         stompClient!, controllerMessage.text);
// //                                     setState(() {
// //                                       controllerMessage.clear();
// //                                     });
// //                                   }
// //                                 },
// //                           backgroundColor: (controllerMessage.text == "" ||
// //                                   controllerMessage.text.isEmpty)
// //                               ? Colors.grey
// //                               : Color(0xff9a00e6),
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
