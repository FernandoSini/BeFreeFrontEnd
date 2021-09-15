import 'package:be_free_v1/Providers/RecoverPasswordProvider.dart';
import 'package:be_free_v1/Providers/VerifyUserProvider.dart';
import 'package:be_free_v1/Screens/ForgotPassword/ForgotPasswordScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyUserScreen extends StatefulWidget {
  @override
  _VerifyUserScreenState createState() => _VerifyUserScreenState();
}

class _VerifyUserScreenState extends State<VerifyUserScreen> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<VerifyUserProvider>(context, listen: false).clear();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<VerifyUserProvider>(context, listen: false).clear();
        await Provider.of<RecoverPasswordProvider>(context, listen: false)
            .clear();
      }
    });
    super.dispose();
  }

  TextEditingController _controller = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    final verifyUserProvider = Provider.of<VerifyUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Color(0xff9a00e6),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
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
              if (verifyUserProvider.hasError == null ||
                  !verifyUserProvider.hasError!)
                Icon(
                  Icons.lock_outline,
                  size: 100,
                )
              else
                Container(
                  child: Text(
                    verifyUserProvider.error!,
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
                  "Problems with Login?",
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
                  keyboardType: TextInputType.text,
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
                    labelText: "Username or email",
                    hintText: "Username or email",
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
                    verifyUserProvider.setData(value);
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 30, right: 30),
                margin: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  child: verifyUserProvider.isLoading!
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        )
                      : Text("Recover password"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff9a00e6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await verifyUserProvider.verifyIfUserExists();
                    if (verifyUserProvider.hasUser!) {
                      _controller.clear();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(
                              verifyUserProvider.dataValue!),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
