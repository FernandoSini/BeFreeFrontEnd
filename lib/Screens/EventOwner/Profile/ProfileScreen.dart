import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Widget/FullScreenWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({this.user});
  final User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
              title: Text(
                "${user?.userName}, ${new DateTime.now().year - new DateFormat("dd/MM/yyyy").parse(user!.birthday!).year}",
                style: TextStyle(
                  fontFamily: "Segoe",
                  color: Colors.pink[400],
                  fontSize: (defaultTargetPlatform == TargetPlatform.android ||
                          defaultTargetPlatform == TargetPlatform.iOS)
                      ? 18
                      : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : AppBar(),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: MediaQuery.of(context).size.height,
          // color: Colors.green,
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  // color: Colors.blue,
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                    color: Colors.blue,
                    image: DecorationImage(
                      image: user!.avatarProfile == null
                          ? AssetImage("assets/avatars/avatar2.png")
                          : NetworkImage("${user!.avatarProfile!.url!}")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (user!.images!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.only(top: 15),
                    clipBehavior: Clip.none,
                    height: user!.images!.length > 3
                        ? 290
                        : MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      clipBehavior: Clip.none,
                      // color: Colors.green,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: user?.images?.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 5),
                        itemBuilder: (context, index) => Container(
                          //  padding: EdgeInsets.only(right: 30, left: 50),
                          margin: EdgeInsets.only(top: 2, left: 2, right: 2),
                          clipBehavior: Clip.none,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                            border:
                                Border.all(color: Color(0xFF9a00e6), width: 2),
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: user?.images?[index] == null
                                  ? AssetImage("/assets/avatars/avatar2.png")
                                  : NetworkImage(user!.images![index].url!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    color: Color(0xFF9a00e6),
                  ),
                ),
                Container(
                  // color: Colors.green,
                  margin: EdgeInsets.only(top: 5),
                  height: (user?.about != null && user!.about!.length >= 100)
                      ? MediaQuery.of(context).size.height * 0.3
                      : MediaQuery.of(context).size.height * 0.17,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Icon(
                              Icons.info_outlined,
                              size: 30,
                              color: Colors.pinkAccent[400],
                            ),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      2, 2), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "About",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 20, top: 10, right: 10),
                        margin: EdgeInsets.only(left: 60, right: 60),
                        child: Text(
                          "${user?.about ?? "This user hasn't write about him/her"}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
