import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Chat.dart';

class ChatWindow extends StatefulWidget {
  var userName;
  ChatWindow({this.userName});
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  String text = 'ABC';
  TextEditingController textController = TextEditingController();

  String _chatAgentId = '1';
  String _chatAgentMessage = 'Hi';
  String _chatUserId = '2';
  String _chatUserMessage = 'Hello';

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
                            _pushChat();
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
  }

  Future<Chat> _pushChat() {
    Firestore db = Firestore.instance;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(
          db.collection('chat').document());
      var dataMap = new Map<String, dynamic>();

      dataMap['agentid'] = _chatAgentId;
      dataMap['agentmessage'] = _chatAgentMessage;
      dataMap['userid'] = _chatUserId;
      dataMap['usermessage'] = _chatUserMessage;
      await tx.set(ds.reference, dataMap);
      return dataMap;
    };
    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return Chat.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }
}
