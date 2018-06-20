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
    // print("document image url");
    // print(document["imageUrl"].toString());
    return new GridTile(
      child: new FlatButton(
        padding: EdgeInsets.all(0.0),
        // child: new Image.network(document["imageUrl"]),
        child: new CachedNetworkImage(
          fadeInDuration: Duration(milliseconds: 0),
          imageUrl: document["imageUrl"].toString()
          ),
        // child: new Text("some"),
        onPressed: () {
          print("tap");
        },
      ),
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
              return new GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                // children: [
                //   new Text("some"),
                //   new Text("yau"),
                //   new Text("third"),
                //   new Text("some"),
                //   new Text("yau"),
                //   new Text("third"),
                //   new Text("some"),
                //   new Text("yau"),
                //   new Text("third"),
                // ],
                // children: List.generate(snapshot.data.documents.length, (index) {
                children: new List<Widget>.generate(
                    snapshot.data.documents.length, (index) {
                  return _buildListItem(
                      context, snapshot.data.documents[index]);
                  return new GridTile(
                      child: new Center(child: new Text("some ${index}")));
                }),
              );
              // return new ListView.builder(
              //     itemCount: snapshot.data.documents.length,
              //     itemBuilder: (context, index) =>
              //         _buildListItem(context, snapshot.data.documents[index]));
            },
          );
  }
}
