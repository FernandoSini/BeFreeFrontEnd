import 'package:be_free_v1/Models/Gender.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Providers/UpdateUserProvider.dart';
import 'package:be_free_v1/Providers/UserProvider.dart';
import 'package:be_free_v1/Screens/Login/LoginScreen.dart';
import 'package:be_free_v1/Screens/Profile/ChangeAvatarScreen.dart';
import 'package:be_free_v1/Screens/Profile/EditProfileScreen.dart';
import 'package:be_free_v1/Widget/Responsive.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class YourProfileScreen extends StatelessWidget {
  YourProfileScreen({this.userData});
  User? userData;
  final storage = new FlutterSecureStorage();

  _logout(context) async {
    await storage.deleteAll();
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final updateUser = Provider.of<UpdateUserProvider>(context);
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
      body: Responsive.isSmallScreen(context)
          ? Container(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
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
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                border: Border.all(
                                  color: userData!.gender == Gender.MALE
                                      ? Colors.blue
                                      : Colors.pinkAccent.shade400,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: userData?.avatarProfile != null
                                    ? NetworkImage(
                                        "http://192.168.0.22:3000/api/${userData?.avatarProfile!.path}")
                                    : AssetImage("assets/avatars/avatar2.png")
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                                radius: 50,
                              ),
                            ),
                            Positioned(
                              left: 60,
                              top: 75,
                              child: Container(
                                height: 35,
                                width: 35,
                                child: Icon(Icons.edit, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: userData!.gender == Gender.MALE
                                        ? Colors.blue
                                        : Colors.pinkAccent.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
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
                      "${userData?.username}, " +
                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(userData!.birthday!).year}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${userData?.firstname} ${userData?.lastname}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${EnumToString.convertToString(userData?.gender)}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                        updateUser.setBirthday(null);
                        updateUser.setNewAbout(null);
                        updateUser.setNewCompany(null);
                        updateUser.setNewEmail(null);
                        updateUser.setNewFirstName(null);
                        updateUser.setNewGender(null);
                        updateUser.setNewLastName(null);
                        updateUser.setNewUsername(null);
                        updateUser.setNewJob(null);
                        updateUser.setNewSchool(null);
                        updateUser.setNewLivesIn(null);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              userId: userData!.id,
                              token: userData!.token,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
            )
          : Container(
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
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                border: Border.all(
                                  color: userData!.gender == Gender.MALE
                                      ? Colors.blue
                                      : Colors.pinkAccent.shade400,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: userData?.avatarProfile != null
                                    ? NetworkImage(
                                        "http://192.168.0.22:3000/api/${userData?.avatarProfile!.path}")
                                    : AssetImage("assets/avatars/avatar2.png")
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                                radius: 80,
                              ),
                            ),
                            Positioned(
                              left: 110,
                              top: 130,
                              child: Container(
                                height: 35,
                                width: 35,
                                child: Icon(Icons.edit, color: Colors.white),
                                decoration: BoxDecoration(
                                    color: userData!.gender == Gender.MALE
                                        ? Colors.blue
                                        : Colors.pinkAccent.shade400,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ],
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
                      "${userData?.username}, " +
                          "${new DateTime.now().year - new DateFormat("dd-MM-yyyy").parse(userData!.birthday!).year}",
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
                      "${userData?.firstname} ${userData?.lastname}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${EnumToString.convertToString(userData?.gender)}",
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
                        updateUser.setBirthday(null);
                        updateUser.setNewAbout(null);
                        updateUser.setNewCompany(null);
                        updateUser.setNewEmail(null);
                        updateUser.setNewFirstName(null);
                        updateUser.setNewGender(null);
                        updateUser.setNewLastName(null);
                        updateUser.setNewUsername(null);
                        updateUser.setNewJob(null);
                        updateUser.setNewSchool(null);
                        updateUser.setNewLivesIn(null);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              userId: userData!.id,
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
