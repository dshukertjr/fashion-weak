import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    return new FlatButton(
      child: new CachedNetworkImage(imageUrl: document["imageUrl"]),
      onPressed: () {
        print("tap");
      },
    );
  }

  Widget build(BuildContext context) {
    return _currentUser == null
        ? new Center(
            child: new CircularProgressIndicator(),
          )
        : new StreamBuilder(
            stream: _firestore
                .collection('clothes')
                .where("uid", isEqualTo: _currentUser.uid)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return new CircularProgressIndicator();
              return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]));
            },
          );
  }
}
