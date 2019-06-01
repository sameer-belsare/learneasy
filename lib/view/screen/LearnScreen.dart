import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learneasy/view/list/ChatList.dart';
import 'package:learneasy/view/list/statusList.dart';
import 'package:learneasy/viewmodel/HomeViewModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:learneasy/data/remote/service/ApiService.dart';
import 'package:learneasy/view/screen/LearnScreen.dart';
import 'package:learneasy/view/list/LearnList.dart';


class LearnScreen extends StatefulWidget {


  var email;
  var usertype;
  LearnScreen({this.email, this.usertype});

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
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
        body: LearnList(email: widget.email, title: 'Learn English', usertype: widget.usertype),
      ),
    );
  }
}
