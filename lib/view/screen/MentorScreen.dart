import 'package:flutter/material.dart';
import 'package:learneasy/view/screen/LearnScreen.dart';
import 'package:learneasy/view/list/LearnList.dart';

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
        ),
        body: LearnList(email: widget.email, title: 'I am ready', usertype: widget.usertype),
      ),
    );
  }
}
