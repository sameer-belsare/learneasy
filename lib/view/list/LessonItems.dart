import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learneasy/model/Chats.dart';
import 'package:learneasy/view/screen/ChatWindow.dart';

class LessonItems extends StatelessWidget {
  final String lesson;

  LessonItems(@required this.lesson);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        lesson,
        style: TextStyle(color: Colors.green),
      ),
      subtitle: Text(""),
      leading: CircleAvatar(
        backgroundColor: Colors.greenAccent,
        radius: 20,
        child: Text(
          lesson.substring(0, 1),
          style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold),
        ),
      ),
      contentPadding: EdgeInsets.only(left: 10.0),
      trailing: Icon(FontAwesomeIcons.angleRight),
      onLongPress: () {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(lesson)));
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                ChatWindow(userName: lesson)));
      },
    );
  }
}
