import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learneasy/view/screen/MentorScreen.dart';
import 'LearnScreen.dart';
import 'package:learneasy/data/firebase/db/table/User.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  final String title;
  SignUp({Key key, this.title}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _signupAutoValidate = false;
  String _signupName;
  String _signupEmail;
  String _signupPassword;
  String _signupPhone;
  String _signupUserType;
  bool _signupObscureText = true;

  bool _cbTextEnglish = false;
  bool _cbTextSpanish = false;
  bool _cbTextTenses = false;
  bool _cbTextPrepositions = false;

  void _signuptoggle() {
    setState(() {
      _signupObscureText = !_signupObscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(widget.title),
        ),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
              key: _signupFormKey,
              autovalidate: _signupAutoValidate,
              child: SignupFormUI(),
            ),
          ),
        ));
  }

  Widget SignupFormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Name'),
          keyboardType: TextInputType.text,
          validator: (String arg) {
            if (arg.length <= 0)
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
            _signupEmail = val;
          },
        ),
        new Stack(alignment: const Alignment(1.0, 1.0), children: <Widget>[
          TextFormField(
            obscureText: _signupObscureText,
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
              _signupPassword = val;
            },
          ),
          new FlatButton(
              onPressed: _signuptoggle,
              child: Text(_signupObscureText ? "Show" : "Hide")),
        ]),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Phone'),
          keyboardType: TextInputType.phone,
          validator: (String arg) {
            if (arg.length <= 0)
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
        DropdownButtonFormField<String>(
          hint: Text('select Mentor/Learner'),
          value: _signupUserType,
          validator: (value) {
            if (value == null) {
              return 'Please select user type';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              _signupUserType = value;
            });
          },
          items: <String>['Mentor', 'Learner'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Language : ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('English'),
              Checkbox(
                activeColor: Colors.deepOrange,
                value: _cbTextEnglish,
                onChanged: (val) {
                  setState(() {
                    _cbTextEnglish = val;
                  });
                },
              ),
              Text('Spanish'),
              Checkbox(
                activeColor: Colors.deepOrange,
                value: _cbTextSpanish,
                onChanged: (val) {
                  setState(() {
                    _cbTextSpanish = val;
                  });
                },
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Text('Skills : ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Tenses'),
              Checkbox(
                activeColor: Colors.deepOrange,
                value: _cbTextTenses,
                onChanged: (val) {
                  setState(() {
                    _cbTextTenses = val;
                  });
                },
              ),
              Text('Prepositions'),
              Checkbox(
                activeColor: Colors.deepOrange,
                value: _cbTextPrepositions,
                onChanged: (val) {
                  setState(() {
                    _cbTextPrepositions = val;
                  });
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
          child: Text('SignUp'),
        ),
        SizedBox(
          height: 50.0,
        ),
        InkWell(
          child: Text('SignIn',
              style: TextStyle(
                  color: Colors.deepOrange,
                  decoration: TextDecoration.underline,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          onTap: () => openLoginScreen(),
        )
      ],
    );
  }

  void performSignup() {
    FocusScope.of(_signupFormKey.currentContext).requestFocus(new FocusNode());
    if (_signupFormKey.currentState.validate()) {
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
      final DocumentSnapshot ds =
          await tx.get(db.collection('user').document());
      var dataMap = new Map<String, dynamic>();

      QuerySnapshot querySnapshot =
          await Firestore.instance.collection("user").getDocuments();
      bool result = true;
      for (DocumentSnapshot documents in querySnapshot.documents) {
        if (documents.data['email'].toString().compareTo(_signupEmail) == 0) {
          result = false;
          break;
        }
      }

      if (result) {
        dataMap['email'] = _signupEmail;
        dataMap['name'] = _signupName;
        dataMap['password'] = _signupPassword;
        dataMap['phone'] = _signupPhone;
        dataMap['usertype'] = _signupUserType;
        await tx.set(ds.reference, dataMap).then((val) {
          if (dataMap['usertype'].compareTo('Learner') == 0) {
            Navigator.of(_signupFormKey.currentContext).pushReplacement(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new LearnScreen(
                        email: dataMap['email'],
                        usertype: dataMap['usertype'])));
          } else if (dataMap['usertype'].toString().compareTo('Mentor') == 0) {
            Navigator.of(_signupFormKey.currentContext).pushReplacement(
                new MaterialPageRoute(
                    builder: (BuildContext context) => new MentorScreen(
                        email: dataMap['email'],
                        usertype: dataMap['usertype'])));
          }
        });
      } else {
        Scaffold.of(_signupFormKey.currentContext).showSnackBar(new SnackBar(
          content: Text("User Already Exists"),
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
    Navigator.of(_signupFormKey.currentContext).pushReplacement(
        new MaterialPageRoute(
            builder: (BuildContext context) => new Login(title: 'SignIn')));
  }
}
