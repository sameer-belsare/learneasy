import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _loginAutoValidate = false;
  String _loginEmail;
  String _loginPassword;
  bool _loginObscureText = true;

  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _signupAutoValidate = false;
  String _signupName;
  String _signupEmail;
  String _signupPassword;
  String _signupPhone;
  bool _signupObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder(
          stream: Firestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('No data..');
            return Container(
              //margin: const EdgeInsets.only(left: 10.0, top: 20.0),
              margin: new EdgeInsets.all(15.0),
              child: new Form(
                key: _loginFormKey,
                autovalidate: _loginAutoValidate,
                child: LoginFormUI(snapshot),
              ),
            );
          }
      ),
    );
  }

  Widget LoginFormUI(AsyncSnapshot snapshot) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (String arg) {
            if(arg.length <= 0)
              return 'Email must not be empty';
            else if(!new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(arg))
              return 'Invalid Email address';
            else
              return null;
          },
          onSaved: (String val) {
            _loginEmail = val;
          },
        ),
        new Stack(
            alignment: const Alignment(1.0, 1.0),
            children: <Widget>[
              TextFormField(
                obscureText: _loginObscureText,
                decoration: const InputDecoration(labelText: 'Password',
                ),
                validator: (String arg) {
                  if(arg.length <= 0)
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
                  child: new Text(_loginObscureText ? "Show" : "Hide")),
            ]
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: () => performLogin(snapshot),
          child: new Text('Login'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text('Register', style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
          onTap: () => openSignupScreen(),
        )
      ],
    );
  }

  void performLogin(AsyncSnapshot snapshot) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Login clicked"),
      duration: Duration(milliseconds: 100),
    ));
    bool result = false;
    if(_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      for(DocumentSnapshot documents in snapshot.data.documents) {
        if(documents.data['email'].toString().compareTo(_loginEmail) == 0 &&
            documents.data['password'].toString().compareTo(_loginPassword) == 0) {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Login success"),
            duration: Duration(milliseconds: 100),
          ));
          result = true;
          break;
        }
      }
      if(result == false) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Invalid credentials"),
          duration: Duration(milliseconds: 100),
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

  void _signuptoggle() {
    setState(() {
      _signupObscureText = !_signupObscureText;
    });
  }

  void openSignupScreen() {
    Navigator.of(context).push(
      //Navigator.pushReplacement(context,
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('REGISTER'),
              ),
              resizeToAvoidBottomPadding: false,
              body: new Container(
                //margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                margin: new EdgeInsets.all(15.0),
                child: new Form(
                  key: _signupFormKey,
                  autovalidate: _signupAutoValidate,
                  child: SignupFormUI(),
                ),
              ),
            );
          }
      ),
    );
  }

  Widget SignupFormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Name'),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if(arg.length <= 0)
              return 'Name must not be empty';
            else
              return null;
          },
          onSaved: (String val) {
            _signupName = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (String arg) {
            if(arg.length <= 0)
              return 'Email must not be empty';
            else if(!new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(arg))
              return 'Invalid Email address';
            else
              return null;
          },
          onSaved: (String val) {
            _signupEmail = val;
          },
        ),
        new Stack(
            alignment: const Alignment(1.0, 1.0),
            children: <Widget>[
              TextFormField(
                obscureText: _signupObscureText,
                decoration: const InputDecoration(labelText: 'Password',
                ),
                validator: (String arg) {
                  if(arg.length <= 0)
                    return 'Password must not be empty';
                  else
                    return null;
                },
                onSaved: (String val) {
                  _signupPassword = val;
                },
              ),
              new FlatButton(
                  onPressed: _signuptoggle,
                  child: new Text(_signupObscureText ? "Show" : "Hide")),
            ]
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Phone'),
          keyboardType: TextInputType.phone,
          validator: (String arg) {
            if(arg.length <= 0)
              return 'Phone must not be empty';
            else
              return null;
          },
          onSaved: (String val) {
            _signupPhone = val;
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: performSignup,
          child: new Text('Register'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text('Login', style: new TextStyle(color: Colors.blue, decoration: TextDecoration.underline),),
          onTap: () => openLoginScreen(),
        )
      ],
    );
  }

  void performSignup() {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Register clicked"),
      duration: Duration(milliseconds: 200),
    ));
    if(_signupFormKey.currentState.validate()) {
      _signupFormKey.currentState.save();

      /*Future<User> user = createUser();
      if(user.asStream().isEmpty == true) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Signup failed"),
          duration: Duration(milliseconds: 100),
        ));
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Signup success"),
          duration: Duration(milliseconds: 100),
        ));
      }*/
      createUser();
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Signup success"),
        duration: Duration(milliseconds: 100),
      ));
    } else {
      setState(() {
        _signupAutoValidate = true;
      });
    }
  }

  Future<User> createUser() async {
    Firestore db = Firestore.instance;
    //CollectionReference userCollectionRef = db.collection('Users');
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(db.collection('user').document());
      var dataMap = new Map<String, dynamic>();

      QuerySnapshot querySnapshot = await Firestore.instance. collection("user").getDocuments();
      bool result = true;
      for(DocumentSnapshot documents in querySnapshot.documents) {
        if(documents.data['email'].toString().compareTo(_signupEmail) == 0) {
          result = false;
          break;
        }
      }

      if(result) {
        dataMap['email'] = _signupEmail;
        dataMap['name'] = _signupName;
        dataMap['password'] = _signupPassword;
        dataMap['phone'] = _signupPhone;
        await tx.set(ds.reference, dataMap);
      }

      return dataMap;
    };

    return Firestore.instance.runTransaction(createTransaction).then((mapData) {
      return User.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  void openLoginScreen() {
    Navigator.pop(context);
    /*Navigator.pushReplacement(context,
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('Login'),
              ),
              resizeToAvoidBottomPadding: false,
              body: StreamBuilder(
                  stream: Firestore.instance.collection('Users').snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return const Text('No data..');
                    return Container(
                      //margin: const EdgeInsets.only(left: 10.0, top: 20.0),
                      margin: new EdgeInsets.all(15.0),
                      child: new Form(
                        key: _loginFormKey,
                        autovalidate: _loginAutoValidate,
                        child: LoginFormUI(snapshot),
                      ),
                    );
                  }
              ),
            );
          }
      ),
    );*/
  }
}

