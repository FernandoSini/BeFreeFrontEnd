import 'package:be_free_front/Models/Gender.dart';
import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Screens/Login/LoginScreen.dart';
import 'package:be_free_front/Screens/Profile/ChangeAvatarScreen.dart';
import 'package:be_free_front/Screens/Profile/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

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
              margin: EdgeInsets.only(top: 35),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChangeAvatarScreen(
                          user: userData,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(65),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      border: Border.all(
                        color: userData!.gender == "MALE"
                            ? Colors.blue
                            : Colors.pinkAccent.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: userData?.avatarProfile != null
                          ? NetworkImage("${userData?.avatarProfile!.url}")
                          : AssetImage("assets/avatars/avatar2.png")
                              as ImageProvider,
                      /* child: ClipOval(
                        child: userData?.avatar != null
                            ? Image.network("${userData?.avatar}")
                            : Image.asset("assets/avatars/avatar2.png"),
                      ), */
                      backgroundColor: Colors.transparent,
                      radius: 80,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${userData?.userName}, " +
                    "${new DateTime.now().year - new DateFormat("dd/MM/yyyy").parse(userData!.birthday!).year}",
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
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${userData?.gender}",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 80, right: 80),
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(
                        userId: userData!.idUser,
                        token: userData!.token,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(left: 80, right: 80),
              child: ElevatedButton.icon(
                icon: Icon(Icons.exit_to_app_sharp),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF9a00e6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () => _logout(context),
              ),
            )
          ],
        ),
      ),
    );
  }
}
