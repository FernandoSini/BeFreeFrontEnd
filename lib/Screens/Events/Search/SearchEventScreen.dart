import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/Event.dart';
import 'package:be_free_v1/Models/EventStatus.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/SearchEventProvider.dart';
import 'package:be_free_v1/Screens/Events/AboutEventScreen/AboutEventScreen.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class SearchEventScreen extends StatefulWidget {
  SearchEventScreen(this.user);
  final User? user;
  @override
  _SearchEventScreenState createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  TextEditingController controllerSearch = TextEditingController(text: "");
  final Api api = new Api();

  // @override
  // void initState() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) async {
  //     if (mounted) {
  //       Provider.of<SearchEventProvider>(context, listen: false);
  //     }
  //   });
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     Provider.of<SearchEventProvider>(context, listen: false);
  //   });
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<SearchEventProvider>(context, listen: false).dispose();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Search Events",
          style: TextStyle(
              fontFamily: "Segoe",
              color: Colors.pinkAccent[400],
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
      ),
      body: Container(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              child: Consumer<SearchEventProvider>(
                builder: (_, searchProvider, __) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: TextFormField(
                      controller: controllerSearch,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20, bottom: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.pinkAccent.shade400),
                        ),
                        suffixIcon: IconButton(
                          icon: searchProvider.isLoaded
                              ? Icon(Icons.close)
                              : Icon(Icons.search),
                          color: Colors.grey,
                          onPressed: () async {
                            if (controllerSearch.text.isEmpty ||
                                controllerSearch.text == "" ||
                                searchProvider.isLoaded) {
                              controllerSearch.clear();
                              searchProvider.clearList();
                              searchProvider.setLoaded(false);
                            } else {
                              await searchProvider.searchEventByName(
                                  controllerSearch.text, widget.user!.token!);
                              controllerSearch.clear();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Consumer<SearchEventProvider>(
                builder: (_, search, __) {
                  if (!search.isLoading) {
                    if (search.hasError) {
                      return Container(
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 200,
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
                                child: Text(search.errorText!),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (search.eventData!.isEmpty) {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    }
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: search.eventData?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AboutEventScreen(
                                    event: search.eventData?[index]),
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
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: search.eventData?[index]
                                                        .eventPhoto !=
                                                    null
                                                ? NetworkImage(
                                                    "${search.eventData?[index].eventPhoto?.path}")
                                                : AssetImage(
                                                        "assets/avatars/avatar2.png")
                                                    as ImageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 10),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Start Date: ' +
                                            '${search.eventData?[index].endDate.toString().substring(0, 10) ?? "Without date"}' +
                                            '  ' +
                                            'End Date: ' +
                                            '${search.eventData?[index].endDate.toString().substring(0, 10) ?? "Without description"}',
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
                                        '${search.eventData?[index].eventName ?? "Without description"}',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Address: ${search.eventData?[index].eventLocation ?? "Without address"}',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '${EnumToString.convertToString(search.eventData![index].eventStatus)}',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '${search.eventData?[index].users!.length ?? "Without users"} Going',
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                    ),
                                    if (search.eventData![index].eventStatus ==
                                        EventStatus.INCOMING)
                                      if (search.eventData![index].users!
                                          .contains(widget.user))
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 50),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
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
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Going"),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
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
                                                      child: Icon(
                                                          Icons.done_outline),
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                    ),
                                                    Text("Going"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, right: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    search.eventData?.remove(
                                                        search
                                                            .eventData![index]);
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
                                                      child: Icon(
                                                          Icons.close_outlined),
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                    ),
                                                    Text("Ignore"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    else if (search
                                            .eventData![index].eventStatus ==
                                        EventStatus.HAPPENING)
                                      if (search.eventData![index].users!
                                          .contains(widget.user))
                                        Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
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
                                                  child:
                                                      Icon(Icons.done_outline),
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                ),
                                                Text("Happening"),
                                              ],
                                            ),
                                          ),
                                        )
                                      else
                                        ButtonBar(
                                          alignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
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
                                                      child: Icon(
                                                          Icons.done_outline),
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                    ),
                                                    Text("Going"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 15, right: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    search.eventData?.remove(
                                                        search
                                                            .eventData![index]);
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
                                                      child: Icon(
                                                          Icons.close_outlined),
                                                      margin: EdgeInsets.only(
                                                          right: 10),
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
                                        margin: EdgeInsets.only(
                                            bottom: 15, left: 50),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
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
                                                child:
                                                    Icon(Icons.close_outlined),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                              ),
                                              Text("Ended"),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 200),
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                          colors: [
                            Colors.red,
                            Colors.pink.shade400,
                            Color(0xFF9a00e6),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget? _buttonBarWidget(Event event) {
  //   switch (event.eventStatus!) {
  //     case EventStatus.INCOMING:
  //       if (!event.users!.contains(widget.user))
  //         return ButtonBar(
  //           alignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               margin: EdgeInsets.only(bottom: 15, left: 10),
  //               width: MediaQuery.of(context).size.width * 0.42,
  //               child: ElevatedButton(
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   // primary: Color(0xFF9a00e6),
  //                   primary: Colors.blue,
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       child: Icon(Icons.done_outline),
  //                       margin: EdgeInsets.only(right: 10),
  //                     ),
  //                     Text("Going"),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(bottom: 15, right: 10),
  //               width: MediaQuery.of(context).size.width * 0.42,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Provider.of<SearchEventProvider>(context)
  //                       .eventData!
  //                       .remove(event);
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Color(0xFF9a00e6),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       child: Icon(Icons.close_outlined),
  //                       margin: EdgeInsets.only(right: 10),
  //                     ),
  //                     Text("Ignore"),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       else if(event.users!.contains(widget.user))
  //         return Container(
  //           margin: EdgeInsets.only(bottom: 15, left: 50),
  //           width: MediaQuery.of(context).size.width * 0.7,
  //           child: ElevatedButton(
  //             onPressed: null,
  //             style: ElevatedButton.styleFrom(
  //               primary: Color(0xFF9a00e6),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   child: Icon(Icons.done_outline),
  //                   margin: EdgeInsets.only(right: 10),
  //                 ),
  //                 Text("Going"),
  //               ],
  //             ),
  //           ),
  //         );
  //       break;
  //     case EventStatus.HAPPENING:
  //       return Container(
  //         margin: EdgeInsets.only(bottom: 15),
  //         width: MediaQuery.of(context).size.width * 0.7,
  //         child: ElevatedButton(
  //           onPressed: null,
  //           style: ElevatedButton.styleFrom(
  //             primary: Color(0xFF9a00e6),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 child: Icon(Icons.done_outline),
  //                 margin: EdgeInsets.only(right: 10),
  //               ),
  //               Text("Happening"),
  //             ],
  //           ),
  //         ),
  //       );
  //       break;
  //     default:
  //   }
  // }
}
