import 'package:be_free_front/Models/Gender.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController controllerUserName = TextEditingController(text: "");
  TextEditingController controllerFirstName = TextEditingController(text: "");
  TextEditingController controllerLastName = TextEditingController(text: "");
  TextEditingController controllerEmail = TextEditingController(text: "");
  TextEditingController controllerAbout = TextEditingController(text: "");
  TextEditingController controllerJob = TextEditingController(text: "");
  TextEditingController controllerCompany = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
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
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      Text(
                        "Male",
                        style: TextStyle(color: Color(0xFF9a00e6)),
                      ),
                      Radio(
                        value: Gender.MALE,
                        groupValue: Gender,
                        onChanged: (value) => value,
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
                          groupValue: Gender,
                          onChanged: (value) => print(value),
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
                          groupValue: Gender,
                          onChanged: (value) => print(value),
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
                child: Text("Update"),
                onPressed: () {},
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
