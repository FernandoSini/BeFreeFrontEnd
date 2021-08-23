import 'package:be_free_v1/Screens/Base/BaseScreen.dart';
import 'package:be_free_v1/Providers/LoginProvider.dart';
import 'package:be_free_v1/Screens/Register/RegisterScreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: false,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Color(0xFF9a00e6),
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("./assets/party.png"), fit: BoxFit.cover),
        // ),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              // margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Text(
                "BeFree",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Color(0xFF9a00e6),
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 40, right: 40),
              child: Text(
                loginProvider.hasError ? loginProvider.errorData : "",
                style: TextStyle(color: Colors.red),
                softWrap: true,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
                keyboardType: TextInputType.text,
                controller: usernameController,
                onChanged: (value) {
                  loginProvider.setUserName(value);
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
                  labelText: "Password",
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
                controller: passwordController,
                onChanged: (value) {
                  loginProvider.setPassword(value);
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 25, right: 25),
              height: 55,
              child: TextButton(
                child: loginProvider.isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                style: TextButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xff9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  var userData = await loginProvider.login(
                      loginProvider.userNameData!, loginProvider.passwordData!);
                  if (loginProvider.isLogged) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BaseScreen(
                          userData: userData,
                        ),
                      ),
                    );
                    loginProvider.setUserName("");
                    loginProvider.setPassword("");
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              height: 55,
              child: TextButton(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                style: TextButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Color(0xff9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
