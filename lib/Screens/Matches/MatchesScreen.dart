import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Matches",
          style: TextStyle(
            fontFamily: "Segoe",
            fontWeight: FontWeight.bold,
            color: Colors.pink[400],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: Text("Your Matches"),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.red,
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage("assets/avatars/avatar2.png"),
                        foregroundImage:
                            AssetImage("assets/avatars/avatar2.png"),
                        // minRadius: 10,
                        // maxRadius: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.red,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      // color: Colors.black,
                      margin: EdgeInsets.only(
                        top: 30,
                        bottom: 30,
                        left: 20,
                      ),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        // color: Colors.blue,
                        child: Icon(
                          Icons.email,
                          size: 50,
                        ),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
