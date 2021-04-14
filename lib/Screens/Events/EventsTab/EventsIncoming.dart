import 'package:flutter/material.dart';

class EventsIncoming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 15),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(top: 15),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/avatars/avatar2.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                // ButtonBar(
                //   alignment: MainAxisAlignment.start,
                //   children: [
                //     TextButton(
                //       onPressed: () {
                //         // Perform some action
                //       },
                //       child: const Text('ACTION 1'),
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         // Perform some action
                //       },
                //       child: const Text('ACTION 2'),
                //     ),
                //   ],
                // ),

                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 15, right: 30),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9a00e6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.done_outline),
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("Going"),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9a00e6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(Icons.close_outlined),
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("Ignore"),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
