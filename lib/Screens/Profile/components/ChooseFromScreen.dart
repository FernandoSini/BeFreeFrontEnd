import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ChooseFromScreen extends StatefulWidget {
  @override
  _ChooseFromScreenState createState() => _ChooseFromScreenState();
}

class _ChooseFromScreenState extends State<ChooseFromScreen> {
  Future<void> _getImageFromCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    final image = io.File(pickedImage.path);
    imageSelected(image);
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final image = io.File(pickedImage.path);

    imageSelected(image);
  }

  Future<void> imageSelected(io.File image) async {
    final imageCropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.transparent,
        toolbarTitle: "Edit Image ",
        toolbarWidgetColor: Colors.pinkAccent[400],
      ),
      iosUiSettings: IOSUiSettings(
        title: "Edit Image ",
        cancelButtonTitle: "Cancel ",
        doneButtonTitle: "Done",
      ),
    );
    if (imageCropped != null) {
      print(imageCropped.path);
      onImageSelected(imageCropped);
    }
  }

  void onImageSelected(io.File image) {
    List<dynamic> list = [];
    list.add(image);
    Navigator.of(context).pop();
  }

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
          "BeFree",
          style: TextStyle(
            fontFamily: "Segoe",
            color: Colors.pink[400],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 40),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _getImageFromCamera(),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          "Camera",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: "Segoe",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 80,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent[400],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.5,
                    blurRadius: 5,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 40, top: 40),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _getImageFromGallery(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Gallery",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "Segoe",
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.photo_size_select_actual_outlined,
                      color: Colors.white,
                      size: 80,
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF9a00e6).withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1.5,
                    blurRadius: 5,
                    offset: Offset(0, 0), // changes position of shadow
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
