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
                      ? MediaQuery.of(context).size.height * 0.2
                      : MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      user!.school == null
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Icon(
                                      Icons.school_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        "${user!.school}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      user!.job == null
                          ? Container()
                          : Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Icon(
                                      Icons.work_outline,
                                      size: 20,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        "${user!.job}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      user!.livesIn == null
                          ? Container()
                          : Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    child: Icon(
                                      Icons.home_outlined,
                                      size: 20,
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: user!.livesIn == null
                                          ? null
                                          : Text("Lives in: ${user!.livesIn}"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Row(
                        children: [
                          // Container(
                          //   margin: EdgeInsets.only(top: 20, left: 20),
                          //   child: Icon(
                          //     Icons.info_outlined,
                          //     size: 30,
                          //     color: Colors.pinkAccent[400],
                          //   ),
                          //   height: 40,
                          //   width: 40,
                          //   decoration: BoxDecoration(
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Colors.grey.withOpacity(0.2),
                          //         spreadRadius: 1,
                          //         blurRadius: 5,
                          //         offset: Offset(
                          //             2, 2), // changes position of shadow
                          //       ),
                          //     ],
                          //     color: Colors.white,
                          //     shape: BoxShape.circle,
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 30, top: 10),
                            child: Text(
                              "About",
                              style: TextStyle(
                                color: Colors.pinkAccent[400],
                                fontFamily: "Segoe",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 30, top: 10, right: 20),
                        // margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "${user?.about ?? "This user hasn't write about him/her"}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black45),
                          maxLines: 5,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    color: Color(0xFF9a00e6),
                  ),
                ),
                if (user!.images!.isNotEmpty)
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Photos",
                          style: TextStyle(
                            color: Colors.pinkAccent[400],
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 15, right: 15),
                        clipBehavior: Clip.none,
                        height: user!.images!.length > 3
                            ? 200
                            : MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: user?.images?.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 10),
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
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                  color: Color(0xFF9a00e6), width: 2),
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                image: user?.images?[index] == null
                                    ? AssetImage("/assets/avatars/avatar2.png")
                                    : NetworkImage(user!.images![index].url!)
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              child: FullScreenWidget(
                                child: Center(
                                  child: Hero(
                                    tag: "smallImage$index",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: user?.images?[index] != null
                                          ? Image.network(
                                              user!.images![index].url!,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                            )
                                          : Image.asset(
                                              "assets/avatars/avatar2.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
