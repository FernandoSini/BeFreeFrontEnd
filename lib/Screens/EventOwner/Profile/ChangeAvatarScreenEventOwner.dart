// import 'package:flutter/material.dart';

// class ChangeAvatarScreen extends StatefulWidget {
//   @override
//   _ChangeAvatarScreenState createState() => _ChangeAvatarScreenState();
// }

import 'dart:io' as io;

import 'package:be_free_front/Models/EventOwner.dart';
import 'package:be_free_front/Providers/EventOwnerAvatarProvider.dart';
import 'package:be_free_front/Providers/ProviderImage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChangeAvatarScreenEventOwner extends StatefulWidget {
  ChangeAvatarScreenEventOwner({this.owner});

  EventOwner? owner;

  @override
  _ChangeAvatarScreenEventOwnerState createState() =>
      _ChangeAvatarScreenEventOwnerState();
}

class _ChangeAvatarScreenEventOwnerState
    extends State<ChangeAvatarScreenEventOwner> {

  Future<void> _getImageFromCamera(BuildContext context) async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedImage == null) return;
    final image = io.File(pickedImage.path);
    imageSelected(image, context);
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
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
    // List<dynamic> list = [];
    // list.add(image);
    if (widget.owner?.avatarProfile == null) {
      await Provider.of<EventOwnerAvatarProvider>(context, listen: false)
          .uploadAvatar(widget.owner!.eventOwnerId!, image, widget.owner!.token);
      if (Provider.of<EventOwnerAvatarProvider>(context, listen: false).isUploaded) {
        await showSuccessDialog();
      } else {
        await showErrorDialog();
      }
    } else {
      await Provider.of<EventOwnerAvatarProvider>(context, listen: false)
          .changeAvatar(widget.owner!.eventOwnerId!, image, widget.owner!.token);
      if (Provider.of<EventOwnerAvatarProvider>(context, listen: false).isUpdated) {
        await showSuccessDialog();
      } else {
        await showErrorDialog();
      }
    }
  }

  Future<void> showSuccessDialog() async {
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
                  Text("Uploaded/Updated Successfully"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showErrorDialog() async {
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
                  Text(
                      "${Provider.of<EventOwnerAvatarProvider>(context, listen: false).errorText}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // @override
  // void initState() {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) async {
  //     await Provider.of<ProviderImage>(context, listen: false);
  //   });
  //   super.initState();
  // }

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
          "Change your avatar",
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
