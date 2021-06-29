import 'package:be_free_front/Providers/RegisterProvider.dart';
import 'package:be_free_front/Screens/Register/components/NamesScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  TextEditingController userNameController = TextEditingController(text: "");
  TextEditingController firstNameController = TextEditingController(text: "");
  TextEditingController lastNameController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    // final registerProvider = Provider.of<RegisterProvider>(context);
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
              // margin: EdgeInsets.only(bottom: 30),
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
            // const SizedBox(
            //   height: 50,
            // ),
            Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Text(
                "Type your username: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 25),
              child: Consumer<RegisterProvider>(
                builder: (_, registerProvider, __) => TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, right: 30),
                    labelText: "Username",
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
                  controller: userNameController,
                  onChanged: (value) {
                    registerProvider.setUsername(value);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                      builder: (_) => NamesScreen(),
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
