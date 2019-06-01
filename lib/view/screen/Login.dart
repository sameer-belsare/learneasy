import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/view/screen/MentorScreen.dart';
import 'LearnScreen.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  final String title;
  Login({Key key, this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _loginAutoValidate = false;
  String _loginEmail;
  String _loginPassword;
  bool _loginObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(widget.title),
        ),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: Firestore.instance.collection('user').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('');
                return Container(
                  //margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                  margin: new EdgeInsets.all(15.0),
                  child: new Form(
                    key: _loginFormKey,
                    autovalidate: _loginAutoValidate,
                    child: LoginFormUI(snapshot),
                  ),
                );
              }),
        ));
  }

  Widget LoginFormUI(AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (String arg) {
            if (arg.length <= 0)
              return 'Email must not be empty';
            else if (!new RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                .hasMatch(arg))
              return 'Invalid Email address';
            else
              return null;
          },
          onSaved: (String val) {
            _loginEmail = val;
          },
        ),
        new Stack(alignment: const Alignment(1.0, 1.0), children: <Widget>[
          TextFormField(
            obscureText: _loginObscureText,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: (String arg) {
              if (arg.length <= 0)
                return 'Password must not be empty';
              else
                return null;
            },
            onSaved: (String val) {
              _loginPassword = val;
            },
          ),
          new FlatButton(
              onPressed: _toggle,
              child: Text(_loginObscureText ? "Show" : "Hide")),
        ]),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          highlightColor: Colors.deepOrange,
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          onPressed: () => performLogin(snapshot),
          child: Text('SignIn'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text(
            'SignUp',
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
          onTap: () => openSignupScreen(),
        )
      ],
    );
  }

  void performLogin(AsyncSnapshot snapshot) {
    FocusScope.of(context).requestFocus(new FocusNode());
    bool result = false;
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      for (DocumentSnapshot documents in snapshot.data.documents) {
        if (documents.data['email'].toString().compareTo(_loginEmail) == 0 &&
            documents.data['password'].toString().compareTo(_loginPassword) ==
                0) {
          Scaffold.of(_loginFormKey.currentContext).showSnackBar(new SnackBar(
            content: Text("Login success"),
            duration: Duration(milliseconds: 500),
          ));
          if (documents.data['usertype'].compareTo('Learner') == 0) {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new LearnScreen(
                    email: documents.data['email'].toString(),
                    usertype: documents.data['usertype'].toString())));
          } else if (documents.data['usertype']
                  .toString()
                  .compareTo('Mentor') ==
              0) {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new MentorScreen(
                    email: documents.data['email'].toString(),
                    usertype: documents.data['usertype'].toString())));
          }
          result = true;
          break;
        }
      }
      if (result == false) {
        Scaffold.of(_loginFormKey.currentContext).showSnackBar(new SnackBar(
          content: Text("Invalid credentials"),
          duration: Duration(milliseconds: 500),
        ));
      }
    } else {
      setState(() {
        _loginAutoValidate = true;
      });
    }
  }

  void _toggle() {
    setState(() {
      _loginObscureText = !_loginObscureText;
    });
  }

  void openSignupScreen() {
    Navigator.of(_loginFormKey.currentContext).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => new SignUp(title: 'SignUp')));
  }
}
