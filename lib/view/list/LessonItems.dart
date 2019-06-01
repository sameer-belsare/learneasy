import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learneasy/model/Chats.dart';
import 'package:learneasy/view/screen/ChatWindow.dart';

class LessonItems extends StatelessWidget {
  final String lesson;

  LessonItems(@required this.lesson);

  @override
  Widget build(BuildContext context) {
    return makeCard;/*ListTile(
      title: Text(
        lesson,
        style: TextStyle(color: Colors.deepOrange),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrange,
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
    );*/
  }


  static final makeCard = Card(

    elevation: 10.0,
    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
      child: makeListTile,
    ),
  );

  static final makeListTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(FontAwesomeIcons.language, color: Colors.white),
      ),
      title: Text(
        "Learn English",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: Colors.yellowAccent),
          Text(" Intermediate", style: TextStyle(color: Colors.white))
        ],
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
}
