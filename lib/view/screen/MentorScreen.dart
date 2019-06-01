import 'package:flutter/material.dart';
import 'package:learneasy/view/list/LearnList.dart';

import 'package:learneasy/view/screen/Login.dart';

class MentorScreen extends StatefulWidget {
  var email;
  var usertype;
  MentorScreen({this.email, this.usertype});

  @override
  _MentorScreen createState() => _MentorScreen();
}

class _MentorScreen extends State<MentorScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Learn Easy', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
                  // Doing Pop and Push for the smooth closing animation
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Login(title: 'SignIn')));
                },
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
        body: LearnList(
            email: widget.email,
            title: 'I am ready',
            usertype: widget.usertype),
      ),
    );
  }
}
