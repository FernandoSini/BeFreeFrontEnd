import 'dart:io' as io;
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Camera/CameraScreen.dart';
import 'package:be_free_front/Screens/Profile/components/ChooseFromScreen.dart';
import 'package:flutter/material.dart';
import 'package:be_free_front/Models/ImageModel.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:image_picker/image_picker.dart';

class PhotosScreen extends StatefulWidget {
  PhotosScreen({this.user});
  User? user;
  @override
  _PhotosScreenState createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  Widget build(BuildContext context) {
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
                        // crossAxisSpacing: 3,
                        childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemCount: widget.user!.images!.isEmpty
                        ? 0
                        : widget.user!.images?.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.black,
                          image: widget.user!.images!.isEmpty
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(
                                    widget.user!.images![index].url!,
                                  ),
                                  fit: BoxFit.cover,
                                ),

                          // border: Border.all(color: Colors.blue, width: 2),
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChooseFromScreen(user: widget.user!),
                        ),
                      );
                    },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.transparent,
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
