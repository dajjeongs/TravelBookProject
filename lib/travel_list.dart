import 'package:flutter/material.dart';

class travelList extends StatefulWidget {
  @override
  travelListState createState() => travelListState();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class travelListState extends State<travelList> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height * 0.6;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child:
      Padding(
        padding: const EdgeInsets.all(10),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            children: [
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  print('test');
                },
              ),
              ListTile(
                leading: new Icon(Icons.music_note),
                title: new Text('Music'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.videocam),
                title: new Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.share),
                title: new Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}