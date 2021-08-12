import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Providers/UpdateUserProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({this.userId, this.token});
  final String? userId;
  final String? token;
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController controllerUserName = TextEditingController(text: "");

  TextEditingController controllerFirstName = TextEditingController(text: "");

  TextEditingController controllerLastName = TextEditingController(text: "");

  TextEditingController controllerEmail = TextEditingController(text: "");

  TextEditingController controllerAbout = TextEditingController(text: "");

  TextEditingController controllerJob = TextEditingController(text: "");

  TextEditingController controllerCompany = TextEditingController(text: "");

  TextEditingController controllerLivesIn = TextEditingController(text: "");

  TextEditingController controllerSchool = TextEditingController(text: "");

  TextEditingController controllerBirthday = TextEditingController(text: "");
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
                  Text("User updated successfully"),
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
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UpdateUserProvider>(context).dispose();
        Provider.of<UserProvider>(context).dispose();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateUser = Provider.of<UpdateUserProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
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
            Container(
              margin: EdgeInsets.only(top: 20, left: 40, right: 40),
              child: Center(
                child: TextFormField(
                  controller: controllerUserName,
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
                  onChanged: (value) {
                    updateUser.setNewUsername(value);
                  },
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
                  controller: controllerFirstName,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Your first name",
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
                    updateUser.setNewFirstName(value);
                  },
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
                  controller: controllerLastName,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Your last name",
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
                    updateUser.setNewLastName(value);
                  },
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
                  controller: controllerEmail,
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
                  onChanged: (value) => updateUser.setNewEmail(value),
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
                  minLines: 1,
                  maxLines: null,
                  maxLength: 250,
                  controller: controllerAbout,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "About You",
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
                    updateUser.setNewAbout(value);
                  },
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: Center(
                child: TextFormField(
                  controller: controllerJob,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Work",
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
                    updateUser.setNewJob(value);
                  },
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
                  controller: controllerCompany,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Company",
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
                  onChanged: (value) {
                    updateUser.setNewCompany(value);
                  },
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
                  controller: controllerSchool,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "School",
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
                  onChanged: (value) {
                    updateUser.setNewSchool(value);
                  },
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
                  controller: controllerLivesIn,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Lives In",
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
                  onChanged: (value) {
                    updateUser.setNewLivesIn(value);
                  },
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
                  controller: controllerBirthday,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    // hintText: "Update your username",
                    labelText: "Birthday",
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
                  onChanged: (value) {
                    updateUser.setBirthday(value);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Text(
                        "Male",
                        style: TextStyle(color: Color(0xFF9a00e6)),
                      ),
                      Radio(
                        value: Gender.MALE,
                        groupValue: updateUser.gender,
                        onChanged: (value) {
                          updateUser.setNewGender(value);
                        },
                        focusColor: Colors.white,
                        hoverColor: Color(0xFF9a00e6),
                        activeColor: Color(0xFF9a00e6),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          "Female",
                          style: TextStyle(color: Color(0xFF9a00e6)),
                        ),
                        Radio(
                          value: Gender.FEMALE,
                          groupValue: updateUser.gender,
                          onChanged: (value) {
                            updateUser.setNewGender(value);
                          },
                          focusColor: Color(0xFF9a00e6),
                          hoverColor: Color(0xFF9a00e6),
                          activeColor: Color(0xFF9a00e6),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    //padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Text(
                          "NonBinary",
                          style: TextStyle(color: Color(0xFF9a00e6)),
                        ),
                        Radio(
                          value: Gender.NONBINARY,
                          groupValue: updateUser.gender,
                          onChanged: (value) {
                            updateUser.setNewGender(value);
                          },
                          focusColor: Color(0xFF9a00e6),
                          hoverColor: Color(0xFF9a00e6),
                          activeColor: Color(0xFF9a00e6),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              margin: EdgeInsets.only(left: 40, right: 40),
              child: ElevatedButton(
                child: updateUser.isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                      )
                    : Text("Update"),
                onPressed: () async {
                  var userUpdated = await updateUser.updateUser(
                      widget.userId!, widget.token!);
                  if (updateUser.isUpdated) {
                    showDialogSuccess();
                    updateUser.setBirthday(null);
                    updateUser.setNewAbout(null);
                    updateUser.setNewCompany(null);
                    updateUser.setNewEmail(null);
                    updateUser.setNewFirstName(null);
                    updateUser.setNewGender(null);
                    updateUser.setNewLastName(null);
                    updateUser.setNewUsername(null);
                    updateUser.setNewJob(null);
                    updateUser.setNewSchool(null);
                    updateUser.setNewLivesIn(null);
                    userProvider.setUser(userUpdated);
                  } else {
                    showErrorDialog();
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
