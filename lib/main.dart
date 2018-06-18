import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';
import 'dart:core';

import 'home.dart';
import 'login.dart';
import 'compose.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

void signOutFirebase(context) {
  _firebaseAuth.signOut();
  Navigator.of(context).pushReplacementNamed("/login");
}

var currentUser = _firebaseAuth.onAuthStateChanged;

Future<bool> isLoggedin() async {
  final currentUser = await _firebaseAuth.currentUser();
  return currentUser != null;
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Choice',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: new LoginPage(title: 'Login'),
      // home: new QuestionsPage(title: 'Questions'),
      home: new StreamBuilder(
          stream: _firebaseAuth.onAuthStateChanged,
          builder: (context, snap) {
            if (snap.hasError) {
              print(snap.error);
              return new Text("error");
              //somehow let the user know there is an error
            }
            // if (snap.data == null) return new LoginPage(title: "Login");
            return new HomePage(title: "Questions");
          }),
      routes: <String, WidgetBuilder>{
        "/questions": (BuildContext context) =>
            new HomePage(title: 'Questions'),
        "/login": (BuildContext context) => new LoginPage(title: 'Login'),
        "/compose": (BuildContext context) => new ComposePage(title: 'Compose'),
      },
    );
  }
}




