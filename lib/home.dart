import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'questions.dart';
import 'closet.dart';
import 'takePhoto.dart';

import 'dart:async';
import 'dart:core';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  TabController controller;
  IconData fabIcon = Icons.add;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
    controller.addListener(_tabChanged);
  }

  void _tabChanged () {
    // print("tab changed called");
    final tabIndex = controller.index;
    setState(() {
          fabIcon = tabIndex == 0? Icons.add: Icons.camera_alt;
        });
  }

  void _fabPressed() {
    final tabIndex = controller.index;
    // print(tabIndex);
    if(tabIndex == 0){
      Navigator.of(context).pushNamed("/compose");
    }else {
      Navigator.of(context).pushNamed("/takePhoto");
    }
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new QuestionPage(),
          new ClosetPage(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(fabIcon),
        onPressed: () => _fabPressed(),
      ),
      bottomNavigationBar: new Material(
        color: Colors.blue,
        child: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(text: "ホーム",),
            new Tab(text: "クローゼット",),
          ],
        ),
      ),
    );
  }
}
