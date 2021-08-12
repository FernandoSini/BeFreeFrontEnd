import 'package:be_free_v1/Providers/RegisterEventOwnerProvider.dart';
import 'package:be_free_v1/Screens/EventOwner/Login/EventOwnerLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OwnerPassword extends StatelessWidget {
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registerEventProvider =
        Provider.of<RegisterEventOwnerProvider>(context);
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
            // const SizedBox(
            //   height: 30,
            // ),
            Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Text(
                registerEventProvider.hasError
                    ? registerEventProvider.errorValue!
                    : "",
                // "flemissajkdhasjkdhas",
                style: TextStyle(color: Colors.red),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Type your password: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 30, right: 30),
                  labelText: "Password",
                  // counterStyle: TextStyle(
                  //   color: Color(0xff9a00e6),
                  // ),
                  labelStyle: TextStyle(
                    color: Color(0xff9a00e6),
                  ),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF9a00e6)),
                  ),
                  // hintText: "Password",
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5,
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xff9a00e6),
                    ),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: passwordController,
                onChanged: (value) {
                  registerEventProvider.setPassword1(value);
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 30, right: 30),
                  labelText: "Validate your password",
                  // counterStyle: TextStyle(
                  //   color: Color(0xff9a00e6),
                  // ),
                  labelStyle: TextStyle(
                    color: Color(0xff9a00e6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF9a00e6)),
                  ),
                  // hintText: "Password",
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5,
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xff9a00e6),
                    ),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                controller: password2Controller,
                onChanged: (value) {
                  registerEventProvider.setPassword2(value);
                },
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
                  onSurface: Color(0xff9a00e6),
                  primary: Color(0xff9a00e6),
                  elevation: 5,
                  // backgroundColor: Color(0xff9a00e6) ?? Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: registerEventProvider.password1Value == null ||
                        !registerEventProvider.isPasswordValid
                    ? null
                    : () async {
                        await registerEventProvider.register();
                      },
              ),
            ),
            if (registerEventProvider.isLoading)
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Color(0xFF9a00e6),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Creating account, please wait a little"),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (registerEventProvider.isEventOwnerRegistered)
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => EventOwnerLogin(),
                                ),
                                (Route route) => false);

                            registerEventProvider.setUserName("");
                            registerEventProvider.setEmail("");
                            registerEventProvider.setPassword1("");
                            registerEventProvider.setPassword2("");
                            registerEventProvider
                                .setIsEventOwnerRegistered(false);
                            registerEventProvider.setErrorValue(false);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                "${registerEventProvider.messageRegistered} Click here to back to login screen"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(),
          ],
        ),
      ),
    );
  }
}
