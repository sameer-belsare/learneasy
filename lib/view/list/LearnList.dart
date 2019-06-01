import 'package:flutter/material.dart';
import 'package:learneasy/view/list/LessonItems.dart';

class LearnList extends StatefulWidget {
  /*LearnList(String s){
    this.title = s;
  }*/
  String title;

  var email;
  var usertype;
  LearnList({this.email, this.title, this.usertype});

  @override
  _LearnListState createState() => _LearnListState(title);
}

class _LearnListState extends State<LearnList> {
  _LearnListState(String s) {
    this.title = s;
  }
  String title;
  List<String> learnList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    learnList.add(title);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: learnList.length,
        itemBuilder: (_, int index) {
          var lesson = learnList[index];
          return LessonItems(lesson, widget.email, widget.usertype);
        });
  }
}
