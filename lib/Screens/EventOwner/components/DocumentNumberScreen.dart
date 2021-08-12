import 'package:be_free_v1/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_v1/Screens/EventOwner/components/DocumentNumberScreen.dart';
import 'package:be_free_v1/Screens/EventOwner/components/EmailOwnerScreen.dart';
import 'package:be_free_v1/Screens/EventOwner/components/OwnerPasswordScreen.dart';
import 'package:be_free_v1/Screens/Register/components/PasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentNumberScreen extends StatelessWidget {
  TextEditingController documentNumberController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              child: Text(
                "BeFree",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Color(0xFF9a00e6),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              alignment: Alignment.center,
              child: Text(
                "To create a event we need a document number to prove you are real:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 25),
              child: Consumer<RegisterEventOwnerProvider>(
                builder: (_, registerEventOwner, __) => TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, right: 30),
                    labelText: "Document number",
                    // counterStyle: TextStyle(
                    //   color: Color(0xff9a00e6),
                    // ),
                    labelStyle: TextStyle(
                      color: Color(0xff9a00e6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Color(0xff9a00e6),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xFF9a00e6)),
                    ),

                    focusedBorder: OutlineInputBorder(
                      gapPadding: 5,
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xff9a00e6),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: documentNumberController,
                  onChanged: (value) {
                    int data = int.parse(value);
                    registerEventOwner.setDocumentNumber(data);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 25, right: 25),
              height: 55,
              child: ElevatedButton(
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff9a00e6),
                  elevation: 5,
                  // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EmailOwnerScreen(),
                    ),
                  );
                }, /* ??
                    null, */
              ),
            )
          ],
        ),
      ),
    );
  }
}
