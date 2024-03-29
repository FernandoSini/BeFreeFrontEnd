import 'dart:io';

import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UserPhotoProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class ChooseFromScreen extends StatefulWidget {
  ChooseFromScreen({this.user});
  User? user;
  @override
  _ChooseFromScreenState createState() => _ChooseFromScreenState();
}

class _ChooseFromScreenState extends State<ChooseFromScreen> {
  Future<void> _getImageFromCamera(BuildContext context) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    final image = io.File(pickedImage.path);
    imageSelected(image, context);
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    final image = io.File(pickedImage.path);

    imageSelected(image, context);
  }

  Future<void> imageSelected(io.File image, BuildContext buildContext) async {
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
      onImageSelected(imageCropped);
    }
  }

  void onImageSelected(io.File image) async {
    var photo = await Provider.of<UserPhotoProvider>(context, listen: false)
        .uploadImage(widget.user!.id!, image, widget.user!.token);
    // widget.user?.photos?.add(photo);

    if (Provider.of<UserPhotoProvider>(context, listen: false).isUploaded) {
      // Provider.of<UserProvider>(context, listen: false)
      //     .updateDataSecurePlace(widget.user);

      await showSuccessDialog(context);
      Navigator.of(context).pop(photo);
    }
    if (Provider.of<UserPhotoProvider>(context, listen: false).hasError) {
      await showErrorDialog(context);
    }
  }

  Future<void> showLoadingDialog(context) async {
    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Container(
              height: 200,
              width: 200,
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
            ),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            content: Center(
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
        },
      );
    }
  }

  Future<void> showSuccessDialog(context) async {
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
                  SizedBox(height: Responsive.isSmallScreen(context) ? 15 : 30),
                  Icon(
                    Icons.check_circle_sharp,
                    color: Colors.green,
                    size: 80,
                  ),
                  Text("Photo uploaded Successfully"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog(context) async {
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
                  SizedBox(height: Responsive.isSmallScreen(context) ? 15 : 30),
                  Icon(
                    Icons.cancel_sharp,
                    color: Colors.red,
                    size: 80,
                  ),
                  Text(
                      "${Provider.of<UserPhotoProvider>(context, listen: false).error}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<UserPhotoProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted)
        Provider.of<UserPhotoProvider>(context, listen: false).dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPhotoProvider = context.watch<UserPhotoProvider>();
    return Scaffold(
      bottomSheet: userPhotoProvider.isLoading
          ? BottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onClosing: () {},
              builder: (context) => Container(
                height: 150,
                child: Column(
                  children: [
                    Container(
                      height: 50,
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
                    ),
                    Container(
                      child: Text("Uploading, please wait a litte."),
                    )
                  ],
                ),
              ),
            )
          : null,
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
                onTap: () => _getImageFromCamera(context),
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
                onTap: () => _getImageFromGallery(context),
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
