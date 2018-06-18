import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:core';

final Firestore _firestore = Firestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// var _currentUser;

class ClosetPage extends StatefulWidget {
  final String title;

  ClosetPage({Key key, this.title}) : super(key: key);

  @override
  _ClosetPageState createState() => new _ClosetPageState();
}

class _ClosetPageState extends State<ClosetPage> {
  var _currentUser;

  @override
  void initState() {
    super.initState();
    _firebaseAuth.onAuthStateChanged.listen((user) {
      setState(() {
        // print("auth state change");
        // print(user);
        _currentUser = user;
      });
    });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return new Container(
        // color: Colors.green,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      image: new NetworkImage(
                          'https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg'),
                    ),
                  ),
                ),
                new Flexible(
                    child: new Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: new Text(document['question']),
                )),
              ],
            ),
            new Divider(),
          ],
        ),
      // onTap: () {
      //   print("tap");
      // }
    );
  }

  Widget build(BuildContext context) {
    return 
    true
    // _currentUser == null
          ? new Center(child: new CircularProgressIndicator())
          : new StreamBuilder(
              stream: _firestore
                  .collection('questions')
                  .where("uid", isEqualTo: _currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return new CircularProgressIndicator();
                return new ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    padding: const EdgeInsets.only(top: 10.0),
                    itemBuilder: (context, index) => _buildListItem(
                        context, snapshot.data.documents[index]));
              },
    );
  }
}
