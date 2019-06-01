import 'package:flutter/material.dart';
import 'viewmodel/HomeViewModel.dart';
import 'view/screen/SplashScreen.dart';
import 'view/screen/HomeScreen.dart';
import 'data/remote/service/ApiService.dart';
import 'Login.dart';

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
