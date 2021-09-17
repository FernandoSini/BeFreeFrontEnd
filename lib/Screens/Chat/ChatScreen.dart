import 'dart:async';
import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Match.dart';
import 'package:be_free_v1/Models/Message.dart';
import 'package:be_free_v1/Models/MessageStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/MessagesProvider.dart';
import 'package:be_free_v1/Screens/Chat/component/YourMessageCard.dart';
import 'package:be_free_v1/Widget/FullScreenWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
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
  double? scrollPosition = 0;
  IO.Socket? socket;
  String? avatarUrl = "";
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  Future<void> connect() async {
    socket = IO.io("${api.url}api/match/chat",
        IO.OptionBuilder().setTransports(['websocket', 'polling']).build());
    socket?.onConnect((data) {
      // print("connected: " + socket.id! + " data: " + data.toString());
    });

    socket?.emit("signIn", widget.you!.id);
    socket?.onError((data) => print("error:" + data.toString()));

    if (_scrollController.hasClients) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.bounceIn);
    }
    // _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    // Timer(Duration(seconds: 1), () {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });
    socket?.on("sendMessage", (data) {
      if (data["matchId"] == widget.match?.matchId) {
        Provider.of<MessagesProvider>(context, listen: false)
            .setMessages(Message.fromJson(data));
      }
    });
  }

  void scrollListener() {
    setState(() {
      scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    connect();
    loadMessages();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position
              .maxScrollExtent /* ,
          duration: Duration(seconds: 1), curve: Curves.easeIn */
          );
      // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    avatarUrl = await storage.read(key: api.key);
    super.didChangeDependencies();
  }

  void loadMessages() {
    socket?.emit("loadMessages", widget.match!.matchId!);
    socket?.on("carregarMensagens", (data) {
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
    socket?.onDisconnect((data) => print("disconnected"));
    socket?.dispose();
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
    socket?.emit("sendMessage", message.toJson());
    return message;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final messageProvider = context.watch<MessagesProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [],
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(messageProvider.messages),
        ),
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
                                  "${api.url}api/${widget.user!.avatarProfile!.path!}",
                                  fit: BoxFit.cover,
                                  height: screenSize.height * 0.5,
                                  width: screenSize.width * 0.95,
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
        height: screenSize.height,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (messageProvider.isLoading)
                  Container(
                    height: screenSize.height,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                    ),
                  )
                else
                  Container(
                      height: defaultTargetPlatform == TargetPlatform.iOS
                          ? screenSize.height * 0.77
                          : screenSize.height * 0.79,
                      clipBehavior: Clip.none,
                      child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemCount: messageProvider.messages?.length != null
                              ? messageProvider.messages!.length
                              : 0,
                          itemBuilder: (context, index) {
                            if (widget.you!.id ==
                                messageProvider.messages?[index].yourId) {
                              return YourMessageCard(
                                  messageStatus: messageProvider
                                      .messages?[index].messageStatus,
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
                      )),
                Container(
                  margin: defaultTargetPlatform == TargetPlatform.android
                      ? EdgeInsets.only(left: 10, right: 10, bottom: 10)
                      : EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
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
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
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
                            } else {}
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
