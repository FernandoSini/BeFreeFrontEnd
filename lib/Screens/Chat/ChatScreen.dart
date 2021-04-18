import 'package:be_free_front/Models/User.dart';
import 'package:be_free_front/Widget/FullScreenWidget.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({this.user});
  User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [],
        iconTheme: IconThemeData(color: Color(0xFF9a00e6)),
        /*  title: Text(
          "${user?.userName}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Segoe",
            color: Color(0xFF9a00e6),
          ),
        ), */

        title: Row(
          children: [
            Container(
              child: CircleAvatar(
                radius: 28,
                child: Container(
                  child: FullScreenWidget(
                    child: Center(
                      child: Hero(
                        tag: "smallImage",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: user?.avatar != null
                              ? Image.network(
                                  user!.avatar!,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                )
                              : Image.asset("assets/avatars/avatar2.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                /*  backgroundImage:
                    NetworkImage(userManagerStore.user.avatar ?? defaultImage),
                radius: 20, */
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${user?.userName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Segoe",
                color: Color(0xFF9a00e6),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
