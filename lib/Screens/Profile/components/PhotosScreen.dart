import 'dart:io' as io;
import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Screens/Camera/CameraScreen.dart';
import 'package:be_free_v1/Screens/Profile/components/ChooseFromScreen.dart';
import 'package:flutter/material.dart';
import 'package:be_free_v1/Models/ImageModel.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
                        childAspectRatio: 0.8),
                    shrinkWrap: true,
                    itemCount: widget.user!.photos!.isEmpty
                        ? 0
                        : widget.user!.photos?.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          setState(() {
                            widget.user?.photos?.removeAt(index);
                          });
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
                                      "${api.url}api/${widget.user!.photos![index].path!}",
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChooseFromScreen(user: widget.user!),
                        ),
                      );
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
