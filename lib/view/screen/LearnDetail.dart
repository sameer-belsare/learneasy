import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learneasy/view/list/ChatList.dart';
import 'package:learneasy/view/list/statusList.dart';
import 'package:learneasy/viewmodel/HomeViewModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:learneasy/data/remote/service/ApiService.dart';
import 'package:learneasy/view/screen/LearnDetail.dart';
import 'package:learneasy/view/list/LearnList.dart';
import 'package:learneasy/view/list/LearnDetailList.dart';


class LearnDetail extends StatefulWidget {
  final String title;
  LearnDetail({Key key, this.title}) : super(key: key);

  @override
  _LearnDetailState createState() => _LearnDetailState();
}

class _LearnDetailState extends State<LearnDetail>
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
          title: Text('Select lesson section', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepOrange,
        ),
        body: LearnDetailList(title: widget.title),
      ),
    );
  }
}
