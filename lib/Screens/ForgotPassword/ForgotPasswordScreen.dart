import 'package:be_free_v1/Providers/RecoverPasswordProvider.dart';
import 'package:be_free_v1/Providers/VerifyUserProvider.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen(this.usernameOrEmail);
  String usernameOrEmail;
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<RecoverPasswordProvider>(context, listen: false)
            .clear();
        await Provider.of<RecoverPasswordProvider>(context, listen: false)
            .setData(widget.usernameOrEmail);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<RecoverPasswordProvider>(context, listen: false)
            .clear();
        await Provider.of<VerifyUserProvider>(context, listen: false).clear();
      }
    });
    super.dispose();
  }

  bool isObscure = false;
  TextEditingController _controller = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final recoverPassword = Provider.of<RecoverPasswordProvider>(context);
    final verifyUserProvider = Provider.of<VerifyUserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff9a00e6),
        ),
      ),
      body: Container(
        child: Column(
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
            if (recoverPassword.isUpdated == null ||
                !recoverPassword.isUpdated!)
              Container()
            else
              Container(
                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                  builder: (_) => LoginScreen(),
                                ),
                                (Route route) => false);
                            recoverPassword.clear();
                            verifyUserProvider.clear();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "Click here to back to login screen",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (recoverPassword.hasErrorUpdate == null ||
                !recoverPassword.hasErrorUpdate!)
              Container()
            else
              Container(
                child: Text(
                  recoverPassword.updateErrorData!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "Write a new password:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.visiblePassword,
                obscureText: isObscure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 30, right: 30),
                  labelStyle: TextStyle(
                    color: Color(0xff9a00e6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xff9a00e6),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure ? Icons.visibility : Icons.visibility_off,
                      color: isObscure ? Colors.grey : Color(0xff9a00e6),
                    ),
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
                  labelText: "New Password",
                  hintText: "New Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Color(0xff9a00e6),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Color(0xff9a00e6),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  recoverPassword.setNewPassword(value);
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 30, right: 30),
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                child: (recoverPassword.isUpdating == null ||
                        !recoverPassword.isUpdating!)
                    ? Text("Recover Password")
                    : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  await recoverPassword.changePassword();
                  if (recoverPassword.isUpdated!) {
                    _controller.clear();
                    verifyUserProvider.clear();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
