import 'package:be_free_front/Providers/EventOwnerProvider.dart';
import 'package:be_free_front/Providers/LoginEventOwnerProvider.dart';
import 'package:be_free_front/Screens/EventOwner/Base/BaseScreenEventOwner.dart';
import 'package:be_free_front/Screens/EventOwner/OwnerRegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EventOwnerLogin extends StatelessWidget {
  TextEditingController usernameController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final loginOwnerProvider = Provider.of<LoginEventOwnerProvider>(context);
    final ownerProvider = Provider.of<EventOwnerProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
              margin: EdgeInsets.only(top: 30),
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
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                loginOwnerProvider.hasError ? loginOwnerProvider.errorData : "",
                // "flemissajkdhasjkdhas",
                style: TextStyle(color: Colors.red),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 20,
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
                  loginOwnerProvider.setUserName(value);
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
                  loginOwnerProvider.setPassword(value);
                },
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(left: 25, right: 25),
              height: 55,
              child: TextButton(
                child: loginOwnerProvider.isLoading
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
                  var ownerData = await loginOwnerProvider.login(
                      loginOwnerProvider.userNameData,
                      loginOwnerProvider.passwordData);
                  if (loginOwnerProvider.isLogged) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BaseScreenEventOwner(
                          eventOwner: ownerData,
                        ),
                      ),
                    );
                    print("logado");
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
                      builder: (_) => OwnerRegisterScreen(),
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
