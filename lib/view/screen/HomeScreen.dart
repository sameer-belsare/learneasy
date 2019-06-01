import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:learneasy/view/list/ChatList.dart';
import 'package:learneasy/view/list/statusList.dart';
import 'package:learneasy/viewmodel/HomeViewModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:learneasy/data/remote/service/ApiService.dart';

class HomeScreen extends StatefulWidget {
  final MainViewModel mainViewModel = MainViewModel(apiInterface: ApiService());

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  Future loadChats() async {
    await widget.mainViewModel.setChats();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp',
      home: Scaffold(
        appBar: AppBar(
          title: Text('WhatsApp', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(FontAwesomeIcons.search), onPressed: () {}),
            IconButton(
              icon: Icon(FontAwesomeIcons.share),
              onPressed: () {},
            )
          ],
          bottom: TabBar(
              controller: tabController,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(
                    icon: Icon(FontAwesomeIcons.facebookMessenger,
                        color: Colors.white),
                    text: 'Chats'),
                Tab(
                    icon: Icon(FontAwesomeIcons.at, color: Colors.white),
                    text: 'Status'),
                Tab(
                    icon: Icon(FontAwesomeIcons.phone, color: Colors.white),
                    text: 'Calls')
              ]),
        ),
        body: ScopedModel<MainViewModel>(
          model: widget.mainViewModel,
          child: TabBarView(
              controller: tabController,
              children: <Widget>[ChatList(), StatusList(), ChatList()]),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
