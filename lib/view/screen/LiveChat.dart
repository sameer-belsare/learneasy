import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/data/local/db/table/Chat.dart';

class LiveChat extends StatefulWidget {
  var userName;
  var email;
  var usertype;
  LiveChat({this.userName, this.email, this.usertype});

  //final String title;

  @override
  _LiveChat createState() => new _LiveChat();
}

class _LiveChat extends State<LiveChat> {
  String text = '';
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => connectToFriday());
  }

  void connectToFriday() {
    Response("Tenses");
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.deepOrange),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    /*AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/sample_auth_json.json").build();
    Dialogflow dialogflow =Dialogflow(authGoogle: authGoogle,language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);*/
    _getChat();

    ChatMessage message = new ChatMessage(
      text: "hi",
      name: "Mentor",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Learner",
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    _pushChat(_textController);

    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Live with Mentor"),
        backgroundColor: Colors.deepOrange,
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  _getChat() {
    Firestore db = Firestore.instance;
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(db.collection('chat').document());

      QuerySnapshot querySnapshot =
          await Firestore.instance.collection("chat").getDocuments();
      DocumentSnapshot documents =
          querySnapshot.documents.elementAt(querySnapshot.documents.length - 1);
      print(documents.data['agentid'].toString());
      print(documents.data['agentmessage'].toString());
      print(documents.data['userid'].toString());
      print(documents.data['usermessage'].toString());
    };
    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      setState(() {
        text = _textController.text;
        _textController.text = '';
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
      final DocumentSnapshot ds =
          await tx.get(db.collection('chat').document());
      var dataMap = new Map<String, dynamic>();

      dataMap['agentid'] = /*widget.email*/ 'alok.kulkarni@gmail.com';
      dataMap['agentmessage'] = textController.text;
      dataMap['userid'] = /*widget.usertype*/ 'nikhil.jadhav@gmail.com';
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

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: new CircleAvatar(child: new Image.asset("assets/friday.jpg")),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(this.name,
                style: new TextStyle(fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subhead),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(child: new Text(this.name[0])),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
