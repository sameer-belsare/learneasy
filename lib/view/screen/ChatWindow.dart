import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Chat.dart';

class ChatWindow extends StatefulWidget {
  var userName;
  var email;
  var usertype;
  ChatWindow({this.userName, this.email, this.usertype});
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String text = '';
  TextEditingController textController = TextEditingController();

  String _chatAgentId;
  String _chatAgentMessage;
  String _chatUserId;
  String _chatUserMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Window',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepOrange,
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
                            FocusScope.of(context).requestFocus(new FocusNode());
                            _pushChat(textController);
                            _getChat();
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

  _getChat() {
    Firestore db = Firestore.instance;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(db.collection('chat').document());

      QuerySnapshot querySnapshot = await Firestore.instance. collection("chat").getDocuments();
      for(DocumentSnapshot documents in querySnapshot.documents) {
        print(documents.data['agentid'].toString());
        print(documents.data['agentmessage'].toString());
        print(documents.data['userid'].toString());
        print(documents.data['usermessage'].toString());
      }
    };
    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      setState(() {
        text = textController.text;
        textController.text = '';
      });
      return Chat.fromMap(mapData);
    }).catchError((error) {
      print('Get chat error: $error');
      return null;
    });
  }

  Future<Chat> _pushChat(TextEditingController textController) {
    Firestore db = Firestore.instance;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(
          db.collection('chat').document());
      var dataMap = new Map<String, dynamic>();

      dataMap['agentid'] = /*widget.email*/'alok.kulkarni@gmail.com';
      dataMap['agentmessage'] = textController.text;
      dataMap['userid'] = /*widget.usertype*/'nikhil.jadhav@gmail.com';
      dataMap['usermessage'] = textController.text;
      await tx.set(ds.reference, dataMap);
      return dataMap;
    };
    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Chat.fromMap(mapData);
    }).catchError((error) {
      print('Push chat error: $error');
      return null;
    });
  }
}
