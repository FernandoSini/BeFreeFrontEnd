import 'package:be_free_v1/Providers/RegisterProvider.dart';
import 'package:be_free_v1/Screens/Base/BaseScreen.dart';
import 'package:be_free_v1/Providers/LoginProvider.dart';
import 'package:be_free_v1/Screens/ForgotPassword/VerifyUserScreen.dart';
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
  bool isObscure = false;
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        backwardsCompatibility: false,
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
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
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
                  suffixIcon: IconButton(
                    icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off),
                    color: isObscure ? Colors.grey : Color(0xff9a00e6),
                    onPressed: () {
                      if (!isObscure) {
                        setState(() {
                          isObscure = true;
                        });
                      } else {
                        setState(() {
                          isObscure = false;
                        });
                      }
                    },
                  ),
                  contentPadding: EdgeInsets.only(left: 30, right: 30),
                  labelText: "Password",
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
                obscureText: isObscure,
                controller: passwordController,
                onChanged: (value) {
                  loginProvider.setPassword(value);
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xff9a00e6),
                ),
                child: Text("Forgot your password?"),
                onPressed: () {
                  loginProvider.setError(false);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VerifyUserScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
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
                  registerProvider.setJob(null);
                  registerProvider.setCompany(null);
                  registerProvider.setSchool(null);
                  registerProvider.setFirstName(null);
                  registerProvider.setLastName(null);
                  registerProvider.setBirthiday(DateTime.now());
                  registerProvider.setLivesIn(null);
                  registerProvider.setEmail(null);
                  registerProvider.setGender(null);
                  registerProvider.setUsername(null);
                  registerProvider.setPassword1(null);
                  registerProvider.setPassword2(null);
                  registerProvider.setIsRegistered(false);
                  registerProvider.setHasError(false);
                  var userData = await loginProvider.login(
                      loginProvider.userNameData, loginProvider.passwordData);
                  if (loginProvider.isLogged) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BaseScreen(
                          userData: userData,
                        ),
                      ),
                    );
                    loginProvider.setUserName(null);
                    loginProvider.setPassword(null);
                    loginProvider.setError(false);
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
                  registerProvider.setJob(null);
                  registerProvider.setCompany(null);
                  registerProvider.setSchool(null);
                  registerProvider.setFirstName(null);
                  registerProvider.setLastName(null);
                  registerProvider.setBirthiday(DateTime.now());
                  registerProvider.setLivesIn(null);
                  registerProvider.setEmail(null);
                  registerProvider.setGender(null);
                  registerProvider.setUsername(null);
                  registerProvider.setPassword1(null);
                  registerProvider.setPassword2(null);
                  registerProvider.setIsRegistered(false);
                  registerProvider.setHasError(false);
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
