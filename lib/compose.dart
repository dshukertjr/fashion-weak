import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:core';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;
var currentUser = _firebaseAuth.onAuthStateChanged;

Future<bool> isLoggedin() async {
  final currentUser = await _firebaseAuth.currentUser();
  return currentUser != null;
}

class ComposePage extends StatefulWidget {
  final String title;
  ComposePage({Key key, this.title}) : super(key: key);

  @override
  _ComposePageState createState() => new _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  final TextEditingController _questionController = new TextEditingController();

  var _myItems = [];


  Future<void> _submitQuestion(context) async{
    final question = _questionController.text;
    if(question == null || question == "") {
      return;
    }
    var currentUser = await _firebaseAuth.currentUser();
    if(currentUser == null) {
      await _firebaseAuth.signInAnonymously();
    currentUser = await _firebaseAuth.currentUser();
    }
    final time = new DateTime.now();
    await _firestore.collection('questions').add({
      'uid': currentUser.uid,
      'question': question,
      'time': time
    });
    Navigator.pop(context);
  }

  void _signOut() {
    _firebaseAuth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("質問投稿")),
        body: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  controller: _questionController,
                  decoration: new InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    // hintText: "Email",
                    labelText: "質問",
                  ),
                  // textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              // new Row(
              //   children: [],
              // ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  child: new Text("ログアウト"),
                  onPressed: () => _signOut(),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  child: new Text("投稿"),
                  onPressed: () => _submitQuestion(context),
                ),
              ),
            ]));
  }
}