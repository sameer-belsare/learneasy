import 'package:flutter/material.dart';
import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        body: Center(
          //child: Text('Hello world'),
          child: Login(title: 'LOGIN'),
        ),
      ),
    );
  }
}

