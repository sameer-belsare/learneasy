import 'package:flutter/material.dart';
import 'package:learneasy/view/list/LessonItems.dart';
import 'package:learneasy/view/list/LearnDetailList.dart';
import 'package:learneasy/view/list/LessionDetailItem.dart';

class LearnDetailList extends StatefulWidget {

  final String title;
  LearnDetailList({Key key, this.title}) : super(key: key);
  @override
  _LearnDetailListState createState() => _LearnDetailListState();
}

class _LearnDetailListState extends State<LearnDetailList> {

  List<String> learnList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    learnList.add("Tenses");
    learnList.add("Prepositions");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: learnList.length,
        itemBuilder: (_, int index) {
          var lesson = learnList[index];
          return LessonDetailItems(title: lesson);
        });
  }

}
