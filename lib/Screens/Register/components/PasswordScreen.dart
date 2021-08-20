import 'package:be_free_v1/Providers/LoginProvider.dart';
import 'package:be_free_v1/Providers/RegisterProvider.dart';
import 'package:be_free_v1/Screens/Base/BaseScreen.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Screens/Register/components/BirthdayScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:provider/provider.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController passwordController = TextEditingController();

  TextEditingController password2Controller = TextEditingController();

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<RegisterProvider>(context, listen: false).dispose();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
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
              margin: EdgeInsets.only(bottom: 20),
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
            //
            Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(bottom: 30),
              padding: EdgeInsets.only(left: 40, right: 40, bottom: 20),
              child: Text(
                registerProvider.hasError ? registerProvider.errorData! : "",
                style: TextStyle(color: Colors.red),
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: true,
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
                  registerProvider.setPassword1(value);
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
                  registerProvider.setPassword2(value);
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
              child: Consumer<RegisterProvider>(
                builder: (_, registerProvider, __) {
                  return ElevatedButton(
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
                    onPressed: registerProvider.password1 == null ||
                            !registerProvider.isPasswordValid
                        ? null
                        : () async {
                            await registerProvider.register();
                            // if (registerProvider.isRegistered) {
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //       MaterialPageRoute(
                            //           builder: (_) => LoginScreen()),
                            //       (Route route) => false);
                            // }
                            // registerProvider.setJob("");
                            // registerProvider.setCompany("");
                            // registerProvider.setSchool("");
                            // registerProvider.setFirstName("");
                            // registerProvider.setLastName("");
                            // registerProvider.setBirthiday(DateTime.now());
                            // registerProvider.setLivesIn("");
                            // registerProvider.mail("");
                            // registerProvider.setGender(null);
                            // registerProvider.setUsername("");
                            // registerProvider.setPassword1("");
                            // registerProvider.setPassword2("");
                            // registerProvider.setIsRegistered(false);
                          },
                  );
                },
              ),
            ),
            if (registerProvider.isLoading)
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
            else if (registerProvider.isRegistered)
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
                                    builder: (_) => LoginScreen()),
                                (Route route) => false);
                            registerProvider.setJob("");
                            registerProvider.setCompany("");
                            registerProvider.setSchool("");
                            registerProvider.setFirstName("");
                            registerProvider.setLastName("");
                            registerProvider.setBirthiday(DateTime.now());
                            registerProvider.setLivesIn("");
                            registerProvider.setEmail("");
                            registerProvider.setGender(null);
                            registerProvider.setUsername("");
                            registerProvider.setPassword1("");
                            registerProvider.setPassword2("");
                            registerProvider.setIsRegistered(false);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                                "${registerProvider.messageValue} Click here to back to login screen"),
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
