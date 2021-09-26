import 'dart:convert';
import 'dart:io';

import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/Profile/components/ChooseFromScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PhotosScreen extends StatefulWidget {
  PhotosScreen({this.user});
  User? user;
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();
  var urlBackend = "";

  Future<bool?> deleteUserPhoto(
      BuildContext context, String photoId, String photoName) async {
    String url = "${api.url}api/users/${widget.user?.id}/photo/delete";
    var body = json.encode({"photoId": photoId, "photoName": photoName});
    http.Response response =
        await http.delete(Uri.parse(url), body: body, headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer ${widget.user?.token}"
    });
    if (response.statusCode == 200) {
      await showSuccessDeleteDialog(context);
      return true;
    } else {
      String error = jsonDecode(response.body)["err"];
      await showDeleteErrorDialog(context, error);
      return false;
    }
  }

  Future<void> showSuccessDeleteDialog(context) async {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Success"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 100),
                child: TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF9a00e6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    Icons.check_circle_sharp,
                    color: Colors.green,
                    size: 80,
                  ),
                  Text("Deleted!"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showDeleteErrorDialog(context, String error) async {
    return showDialog(
      context: context,
      builder: (_) {
        return Container(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Error"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 100),
                child: TextButton(
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF9a00e6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
            content: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text("$error"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
        title: Text(
          "Your photos",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pink[400],
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.none,
              padding: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  GridView.builder(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemCount: widget.user!.photos!.isEmpty
                        ? 0
                        : widget.user!.photos?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () async {
                          // setState(() {
                          //   widget.user?.photos?.removeAt(index);
                          // });
                          if (Platform.isAndroid) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Photo",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete this photo?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var isPhotoDeleted =
                                            await deleteUserPhoto(
                                                    context,
                                                    widget.user!.photos![index]
                                                        .id!,
                                                    widget.user!.photos![index]
                                                        .filename!)
                                                .then((value) {
                                          setState(() {
                                            widget.user?.photos
                                                ?.removeAt(index);
                                            userProvider.updateDataSecurePlace(
                                                widget.user);
                                          });
                                          return value;
                                        });

                                        // if (isPhotoDeleted!) {
                                        //   setState(() {
                                        //     widget.user?.photos
                                        //         ?.removeAt(index);
                                        //   });
                                        // }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                    "Delete Photo",
                                    style: TextStyle(
                                      color: Color(0xFF9a00e6),
                                    ),
                                  ),
                                  content: Text(
                                      "Hey, are you sure that you want to delete this photo?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        var isPhotoDeleted =
                                            await deleteUserPhoto(
                                                    context,
                                                    widget.user!.photos![index]
                                                        .id!,
                                                    widget.user!.photos![index]
                                                        .filename!)
                                                .then((value) {
                                          setState(() {
                                            widget.user?.photos
                                                ?.removeAt(index);

                                            userProvider.updateDataSecurePlace(
                                                widget.user);
                                          });
                                          return value;
                                        });

                                        // if (isPhotoDeleted!) {
                                        //   setState(() {
                                        //     widget.user?.photos?.removeAt(index);
                                        //   });
                                        // }
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            color: Colors.pinkAccent[400]),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.pinkAccent[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5, left: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black),
                            color: Colors.black,
                            image: widget.user!.photos!.isEmpty
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(
                                      "${widget.user!.photos![index].path!}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                child: Text("add photos"),
                onPressed: null ??
                    () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChooseFromScreen(user: widget.user!),
                            ),
                          )
                          .then((value) => setState(() {
                                if (value != null) {
                                  widget.user?.photos?.add(value);
                                  userProvider
                                      .updateDataSecurePlace(widget.user);
                                }
                              }));
                    },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
