import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:async';
import 'dart:core';

final Firestore _firestore = Firestore.instance;
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// var _currentUser;

class QuestionPage extends StatefulWidget {
  final String title;

  QuestionPage({Key key, this.title}) : super(key: key);

  @override
  _QuestionPageState createState() => new _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
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
    // print(document["question"]);
    return new FlatButton(
      child: new Container(
        // color: Colors.green,
        // padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  width: 80.0,
                  height: 80.0,
                  // child: new CachedNetworkImage(
                  //   fadeInDuration: Duration(milliseconds: 0),
                  //   imageUrl: document["imageUrl"] == null?"https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg":document["imageUrl"]),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: new CachedNetworkImageProvider(
                          'https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg'),
                    ),
                  ),
                  // decoration: new BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   image: new CachedNetworkImage(imageUrl: 'https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg'),
                  // ),
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
      ),
      onPressed: () {
        print("question pressed");
      },
    );
  }

  Widget build(BuildContext context) {
    return _currentUser == null
        ? new Center(child: new CircularProgressIndicator())
        : new StreamBuilder(
            stream: _firestore
                .collection('questions')
                .where("uid", isEqualTo: _currentUser.uid)
                .orderBy("time", descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new CircularProgressIndicator();
              return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.only(top: 10.0),
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]));
            },
          );
  }
}
