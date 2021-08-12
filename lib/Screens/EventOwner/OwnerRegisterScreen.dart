import 'package:be_free_v1/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_v1/Screens/EventOwner/components/DocumentNumberScreen.dart';
import 'package:be_free_v1/Screens/EventOwner/components/OwnerPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OwnerRegisterScreen extends StatelessWidget {
  TextEditingController eventOwnerNameController =
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
              alignment: Alignment.center,
              child: Text(
                "What is your name or company name?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 100, left: 25, right: 25, bottom: 25),
              child: Consumer<RegisterEventOwnerProvider>(
                builder: (_, registerEventOwner, __) => TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, right: 30),
                    labelText: "Your name or your company name",
                    // counterStyle: TextStyle(
                    //   color: Color(0xff9a00e6),
                    // ),
                    labelStyle: TextStyle(
                      color: Color(0xff9a00e6),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xff9a00e6))),
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
                  keyboardType: TextInputType.text,
                  controller: eventOwnerNameController,
                  onChanged: (value) {
                    registerEventOwner.setUserName(value);
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
                      builder: (_) => DocumentNumberScreen(),
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
