import 'package:flutter/material.dart';
import 'package:learneasy/view/list/LessonItems.dart';
class LearnList extends StatefulWidget {
  @override
  _LearnListState createState() => _LearnListState();
}

class _LearnListState extends State<LearnList> {

  List<String> learnList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    learnList.add("Learn English");
  }

  @override
  Widget build(BuildContext context) {
     return ListView.builder(
        itemCount: learnList.length,
        itemBuilder: (_, int index) {
          var lesson = learnList[index];
          return LessonItems(lesson);
        });
  }
}
