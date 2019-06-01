import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/view/screen/MentorScreen.dart';
import 'User.dart';
import 'package:learneasy/view/screen/HomeScreen.dart';
import 'view/screen/LearnScreen.dart';

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
  String _signupUserType = 'Learner';
  bool _signupObscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
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
          highlightColor: Colors.deepOrange,
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          onPressed: () => performLogin(snapshot),
          child: new Text('SignIn'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text('SignUp', style: new TextStyle(color: Colors.deepOrange,fontSize: 18, decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
          onTap: () => openSignupScreen(),
        )
      ],
    );
  }

  void performLogin(AsyncSnapshot snapshot) {
    FocusScope.of(context).requestFocus(new FocusNode());
    bool result = false;
    if(_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();

      for(DocumentSnapshot documents in snapshot.data.documents) {
        if(documents.data['email'].toString().compareTo(_loginEmail) == 0 &&
            documents.data['password'].toString().compareTo(_loginPassword) == 0) {
          Scaffold.of(_loginFormKey.currentContext).showSnackBar(new SnackBar(
            content: new Text("Login success"),
            duration: Duration(milliseconds: 500),
          ));
          if(documents.data['usertype'].toString().compareTo('Learner') == 0) {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new LearnScreen()));
          } else{
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (BuildContext context) => new MentorScreen()));
          }
          result = true;
          break;
        }
      }
      if(result == false) {
        Scaffold.of(_loginFormKey.currentContext).showSnackBar(new SnackBar(
          content: new Text("Invalid credentials"),
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

  void _signuptoggle() {
    setState(() {
      _signupObscureText = !_signupObscureText;
    });
  }

  void openSignupScreen() {
    Navigator.of(context).pushReplacement(
      //Navigator.pushReplacement(context,
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                backgroundColor: Colors.deepOrange,
                title: const Text('SignUp'),
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
    Container(
    child: Row(
    children: <Widget>[
        Text("Your are $_signupUserType :   ",style: TextStyle( fontWeight:FontWeight.bold)),
        DropdownButton<String>(
          hint: Text('select other'),
        items: <String>['Mentor', 'Learner'].map((String value) {
        return DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
        );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _signupUserType = value;
          });
        },
        )])),
        SizedBox(
          height: 10.0,
        ),

        Container(
          child: Row(
            children: <Widget>[

              Text('Language : ',style: TextStyle( fontWeight:FontWeight.bold)),
              Text('English'),
              Checkbox(
                value: false,
                onChanged: (val){

                },
              ),
              Text('Spanish'),
              Checkbox(
                value: false,
                onChanged: (val){

                },
              )
            ],
          ),

    ),

        Container(
          child: Row(

            children: <Widget>[
              Text('Skills : ',style: TextStyle( fontWeight:FontWeight.bold)),
              Text('Tenses'),
              Checkbox(
                value: false,
                onChanged: (val){

                },
              ),
              Text('Prepositions'),
              Checkbox(
                value: false,
                onChanged: (val){

                },
              )
            ],
          ),

        ),

        RaisedButton(
          highlightColor: Colors.deepOrange,
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          onPressed: performSignup,
          child: new Text('SignUp'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text('SignIn', style: new TextStyle(color: Colors.deepOrange, decoration: TextDecoration.underline,fontSize:18,fontWeight: FontWeight.bold)),
          onTap: () => openLoginScreen(),
        )
      ],
    );
  }

  void performSignup() {
    FocusScope.of(_signupFormKey.currentContext).requestFocus(new FocusNode());
    if(_signupFormKey.currentState.validate()) {
      _signupFormKey.currentState.save();
      createUser();
    } else {
      setState(() {
        _signupAutoValidate = true;
      });
    }
  }

  Future<User> createUser() async {
    Firestore db = Firestore.instance;
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
        dataMap['usertype'] = _signupUserType;
        await tx.set(ds.reference, dataMap).then((void val) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => new HomeScreen()));
        });
      } else {
        Scaffold.of(_signupFormKey.currentContext).showSnackBar(new SnackBar(
          content: new Text("User Already Exists"),
          duration: Duration(milliseconds: 500),
        ));
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
    Navigator.of(_signupFormKey.currentContext).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => new Login(title: 'SignIn')));
  }
}

