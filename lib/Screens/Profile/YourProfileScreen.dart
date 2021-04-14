import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:be_free_front/Screens/Profile/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class YourProfileScreen extends StatelessWidget {
  YourProfileScreen({this.userData});
  User? userData;
  final storage = new FlutterSecureStorage();

  _logout(context) async {
    await storage.deleteAll();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Profile",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: CircleAvatar(
                backgroundImage: userData?.avatar != null
                    ? NetworkImage("${userData?.avatar}")
                    : AssetImage("assets/avatars/avatar2.png") as ImageProvider,
                radius: 80,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${userData?.userName}, ${userData?.birthday}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${userData?.firstName} ${userData?.lastName}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 80, right: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => EditProfileScreen()));
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // margin: ,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.edit),
                      ),
                      Container(
                        // margin: EdgeInsets.only(left: 30, right: 80),
                        padding: EdgeInsets.only(left: 50, right: 70),
                        child: Text("Edit Profile"),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 80, right: 80),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () => _logout(context),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // margin: ,
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.exit_to_app_sharp),
                      ),
                      Container(
                        // margin: EdgeInsets.only(left: 30, right: 80),
                        padding: EdgeInsets.only(left: 50, right: 85),
                        child: Text("Logout"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
