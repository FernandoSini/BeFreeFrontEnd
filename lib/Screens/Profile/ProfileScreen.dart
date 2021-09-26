import 'package:be_free_v1/Api/Api.dart';
import 'package:be_free_v1/Models/User.dart';
import 'package:be_free_v1/Widget/FullScreenWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({this.user});
  final User? user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final storage = new FlutterSecureStorage();
  final Api api = new Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? AppBar(
              backgroundColor: Colors.transparent,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark),
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
              title: Text(
                widget.user!.birthday!.contains("/")
                    ? "${widget.user?.username}, ${new DateTime.now().year - new DateFormat("dd/MM/yyyy").parse(widget.user!.birthday!).year}"
                    : "${widget.user?.username}, ${new DateTime.now().year - new DateFormat("dd-mm-yyyy").parse(widget.user!.birthday!).year}",
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
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                  height: MediaQuery.of(context).size.height * 0.35,
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
                      image: widget.user!.avatarProfile == null
                          ? AssetImage("assets/avatars/avatar2.png")
                          : NetworkImage("${widget.user!.avatarProfile!.path!}")
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
                  margin: EdgeInsets.only(top: 5),
                  height: (widget.user?.about != null &&
                          widget.user!.about!.length >= 100)
                      ? MediaQuery.of(context).size.height * 0.2
                      : MediaQuery.of(context).size.height * 0.2,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      widget.user!.school == null
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
                                        "${widget.user!.school}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      widget.user!.job == null
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
                                        "${widget.user!.job}",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      widget.user!.livesIn == null
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
                                      child: widget.user!.livesIn == null
                                          ? null
                                          : Text(
                                              "Lives in: ${widget.user!.livesIn}"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Row(
                        children: [
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
                          "${widget.user?.about ?? "This user hasn't write about him/her"}",
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
                if (widget.user!.photos != null)
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
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.only(
                            top: 15, bottom: 15, left: 15, right: 15),
                        clipBehavior: Clip.none,
                        height: widget.user!.photos!.length > 3
                            ? 200
                            : MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: widget.user?.photos?.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, crossAxisSpacing: 10),
                          itemBuilder: (context, index) => Container(
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
                                image: widget.user?.photos?[index] == null
                                    ? AssetImage("/assets/avatars/avatar2.png")
                                    : NetworkImage(
                                            "${widget.user!.photos![index].path!}")
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
                                      child: widget.user?.photos?[index] != null
                                          ? Image.network(
                                              "${widget.user!.photos![index].path!}",
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
                  )
                else
                  Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
