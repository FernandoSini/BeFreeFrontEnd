import 'package:be_free_v1/Models/EventOwner.dart';
import 'package:be_free_v1/Providers/UpdateEventOwnerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProfileScreenEventOwner extends StatefulWidget {
  EditProfileScreenEventOwner(this.ownerData);
  EventOwner? ownerData;

  @override
  _EditProfileScreenEventOwnerState createState() =>
      _EditProfileScreenEventOwnerState();
}

class _EditProfileScreenEventOwnerState
    extends State<EditProfileScreenEventOwner> {
  TextEditingController controllerEventOwnerName =
      TextEditingController(text: "");

  TextEditingController controllerDocumentNumber =
      TextEditingController(text: "");

  TextEditingController controllerEventOwnerEmail =
      TextEditingController(text: "");

  Future<void> showDialogSuccess() {
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
                  Text("Event Owner updated successfully"),
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
                  Text("Error When trying to updating your profile"),
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
    final updateOwnerProvider = Provider.of<UpdateEventOwnerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Edit Your Profile",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF9a00e6),
        ),
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: TextFormField(
                  controller: controllerEventOwnerName,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Your new username",
                    labelStyle: TextStyle(
                      color: Color(0xFF9a00e6),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9a00e6),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9a00e6),
                      ),
                    ),
                  ),
                  onChanged: (value) => updateOwnerProvider.setEmail(value),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: TextFormField(
                    controller: controllerDocumentNumber,
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      // hintText: "Update your username",
                      labelText: "Your new Document Number",
                      labelStyle: TextStyle(color: Color(0xFF9a00e6)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF9a00e6),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF9a00e6),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      var valor = int.tryParse(value);
                      updateOwnerProvider.setDocumentNumber(valor);
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: TextFormField(
                  controller: controllerEventOwnerEmail,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Your email",
                    labelStyle: TextStyle(color: Color(0xFF9a00e6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9a00e6),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9a00e6),
                      ),
                    ),
                  ),
                  onChanged: (value) => updateOwnerProvider.setEmail(value),
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 40, right: 40),
              child: ElevatedButton(
                child: updateOwnerProvider.isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      )
                    : Text("Update"),
                onPressed: () async {
                  updateOwnerProvider.updateEventOwner(widget.ownerData!.token!,
                      widget.ownerData!.eventOwnerId!);
                  if (updateOwnerProvider.isUpdated) {
                    await showDialogSuccess();
                    controllerDocumentNumber.clear();
                    controllerEventOwnerEmail.clear();
                    controllerEventOwnerName.clear();
                    updateOwnerProvider.setDocumentNumber(null);
                    updateOwnerProvider.setEmail(null);
                    updateOwnerProvider.setEventOwnerName(null);
                  }
                  if (updateOwnerProvider.hasError) {
                    await showErrorDialog();
                    controllerDocumentNumber.clear();
                    controllerEventOwnerEmail.clear();
                    controllerEventOwnerName.clear();
                    updateOwnerProvider.setDocumentNumber(null);
                    updateOwnerProvider.setEmail(null);
                    updateOwnerProvider.setEventOwnerName(null);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
