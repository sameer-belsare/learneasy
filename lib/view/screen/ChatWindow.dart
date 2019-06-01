import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  var userName;
  ChatWindow({this.userName});
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String text = 'ABC';
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Window',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'U',
                style: TextStyle(color: Colors.black),
              ),
            ),
            title: Text(widget.userName),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(text),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              text = text + '\n' + textController.text;
                              textController.text = '';
                            });
                          }),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
            ],
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
