import 'package:flutter/material.dart';
import 'view/screen/SplashScreen.dart';
import 'package:learneasy/view/screen/Login.dart';

void main() => runApp(LearnEasyApp());

class LearnEasyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Learn Easy',
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/Login': (BuildContext content) => Login(title: 'SignIn')
        },
        debugShowCheckedModeBanner: false);
  }
}
